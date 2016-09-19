module Import
  # Process a hash of product attributes and create or update a product
  class VariantImporter
    def initialize(spree_product, attributes, options = {})
      @key_to_match = options[:key_to_match] || :sku
      @item_delimiter = options[:item_delimiter] || ","
      @key_delimiter = options[:key_delimiter] || ":"
      @spree_product = spree_product
      @variant = Intermediates::Variant.from_csv_attributes(attributes, item_delimiter: @item_delimiter, key_delimiter: @key_delimiter)
    end

    # TODO: use key_to_match instead of hard coded sku
    # TODO: use logger instead of puts
    def import
      spree_variant = update_or_create
      set_stock(spree_variant) unless @variant.stock.blank?
      add_images(spree_variant) unless @variant.image_urls.blank?
      spree_variant
    end

    private

    def update_or_create
      value_to_find = @variant.sku
      spree_attributes = @variant.to_spree_attributes(@spree_product)
      spree_variant = find_spree_variant(value_to_find)
      if spree_variant.present?
        puts "Updating existing variant #{@variant.sku} for product #{@spree_product.sku}"
        spree_variant.update!(spree_attributes)
      else
        puts "Creating new variant #{@variant.sku} for product #{@spree_product.sku}"
        spree_variant = @spree_product.variants.create!(spree_attributes)
      end
      spree_variant
    end

    def set_stock(spree_variant, stock_location = nil)
      stock_location ||= default_stock_location
      quantity = @variant.stock
      stock_location.stock_item_or_create(spree_variant).set_count_on_hand(quantity)
    end

    # TODO: Handle errors
    # TODO: Remove unused images
    def add_images(spree_variant)
      @variant.image_urls.each_with_index do |url, index|
        filename = File.basename(url)
        spree_image = spree_variant.images.find_by(attachment_file_name: filename)
        if spree_image.present?
          puts "Using existing image: #{filename}"
        else
          puts "Downloading image: #{url}"
          spree_variant.images.create!(attachment: url, position: index + 1)
        end
      end
    end

    def find_spree_variant(value_to_find)
      @spree_product.variants.find_by(@key_to_match => value_to_find)
    end

    def default_stock_location
      Spree::StockLocation.where(default: true).first ||
        Spree::StockLocation.all.select { |sl| sl.name.casecmp("default") }.first
    end
  end
end
