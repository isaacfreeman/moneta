require "smarter_csv"
require "open-uri"

def uri?(string)
  uri = URI.parse(string)
  %w( http https ).include?(uri.scheme)
rescue URI::BadURIError
  false
rescue URI::InvalidURIError
  false
end

def download_file(csv_file_or_url, tmp_file_name = "download.txt")
  filepath = "#{Rails.root}/tmp/#{tmp_file_name}.csv"
  download = open(csv_file_or_url)
  IO.copy_stream(download, filepath)
  filepath
end

# TODO: products and variants in one go, so we don't expose products without variants on a live site
# TODO: option to flush existing products, variants and images before import ()
namespace :import do
  namespace :csv do
    desc "Import products from CSV"
    task products: :environment do
      # TODO: error if ARGV doesn't include filename
      source = ARGV.second
      task source.to_sym {}

      item_delimiter = ENV["item_delimiter"] || ","
      key_delimiter = ENV["key_delimiter"] || ":"
      hierarchy_delimiter = ENV["hierarchy_delimiter"] || ">"

      csv_file = if uri?(source)
                   download_file(source, "downloaded_products")
                 else
                   source
                 end

      rows = SmarterCSV.process(csv_file)
      row_count = rows.count

      import_errors = {}
      rows.each_with_index do |row, i|
        begin
          puts
          puts "Row #{i} of #{row_count}"
          sku = row[:sku].to_s.to_sym # SKU field might be parsed as a number
          Import::ProductImporter.new(row, item_delimiter: item_delimiter, key_delimiter: key_delimiter, hierarchy_delimiter: hierarchy_delimiter).import
        rescue => error
          import_errors[sku] = error
          puts "Error importing product with SKU #{sku}: #{error}".red
        end
      end

      if import_errors.count.zero?
        puts "Products imported with no errors"
      else
        puts "Products imported with #{import_errors.count} errors"
        import_errors.each do |sku, error|
          puts "  SKU #{sku}: #{error}"
        end
      end
    end

    desc "Import variants from CSV"
    task variants: :environment do
      source = ARGV.second
      task source.to_sym {}

      item_delimiter = ENV["item_delimiter"] || ","
      key_delimiter = ENV["key_delimiter"] || ":"

      csv_file = if uri?(source)
                   download_file(source, "downloaded_variants.csv")
                 else
                   source
                 end

      rows = SmarterCSV.process(csv_file)
      row_count = rows.count

      import_errors = {}
      rows.each_with_index do |row, i|
        begin
          puts
          puts "Row #{i} of #{row_count}"
          sku = row[:sku].to_s.to_sym
          product_sku = row[:product_sku].to_s
          spree_product = Spree::Variant.find_by(sku: product_sku).try(:product)
          raise "Product #{product_sku} doesn't exist yet" unless spree_product.present?
          Import::VariantImporter.new(spree_product, row, item_delimiter: item_delimiter, key_delimiter: key_delimiter).import
        rescue => error
          import_errors[sku] = error
          puts "Error importing variant with SKU #{sku}: #{error}".red
        end
      end

      if import_errors.count.zero?
        puts "Variants imported with no errors"
      else
        puts "Variants imported with #{import_errors.count} errors"
        import_errors.each do |sku, error|
          puts "  SKU #{sku}: #{error}"
        end
      end
    end
  end
end
