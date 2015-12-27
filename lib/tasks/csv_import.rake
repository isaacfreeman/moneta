require 'smarter_csv'

namespace :csv do
  namespace :import do
    desc "Import products from CSV"
    task products: :environment do
      csv_file = ARGV.last
      task csv_file.to_sym {}
      rows = SmarterCSV.process(csv_file)

      rows.each do |row|
        Moneta::ProductImporter.new(row).import
      end
    end
  end
end
