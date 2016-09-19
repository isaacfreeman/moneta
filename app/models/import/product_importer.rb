module Import
  # Process a hash of product attributes and create or update a product
  class ProductImporter
    def initialize(attributes, options = {})
      @key_to_match = options[:key_to_match] || :sku
      @item_delimiter = options[:item_delimiter] || ","
      @key_delimiter = options[:key_delimiter] || ":"
      @hierarchy_delimiter = options[:hierarchy_delimiter] || ">"
      @product = Intermediates::Product.from_csv_attributes(attributes, item_delimiter: @item_delimiter, key_delimiter: @key_delimiter)
    end

    # TODO: use key_to_match instead of hard coded name
    # TODO: use logger instead of puts
    def import
      spree_product = update_or_create
      # TODO: Move each of these to its own importer class?
      set_stock(spree_product) unless @product.stock.blank?
      add_images(spree_product) unless @product.image_urls.count.zero?
      add_taxons(spree_product) unless @product.taxon_strings.blank?
      spree_product
    end

    private

    def update_or_create
      sku = @product.sku
      spree_product = find_spree_product(sku)
      spree_attributes = @product.to_spree_attributes
      if spree_product.present?
        puts "Updating existing product: #{sku}"
        spree_product.update!(spree_attributes)
      else
        puts "Creating new product: #{sku}"
        spree_product = Spree::Product.create!(spree_attributes)
      end
      spree_product
    end

    def set_stock(spree_product, stock_location = nil)
      stock_location ||= default_stock_location
      variant = spree_product.master
      quantity = @product.stock
      stock_location.stock_item_or_create(variant).set_count_on_hand(quantity)
    end

    # TODO: Handle errors
    # TODO: Remove unused images
    def add_images(spree_product)
      @product.image_urls.each_with_index do |url, index|
        filename = File.basename(url)
        spree_image = spree_product.images.find_by(attachment_file_name: filename)
        if spree_image.present?
          puts "Using existing image: #{filename}"
        else
          puts "Downloading image: #{url}"
          spree_product.images.create!(attachment: url, position: index + 1)
        end
      end
    end

    # TODO: Option to prepend a taxonomy name if there's an implicit taxonomy
    #       that's been assumed e.g. "Menu"
    def add_taxons(spree_product)
      @product.taxon_strings.each do |taxon_string|
        taxonomy_name, *taxon_names = taxon_string.split(@hierarchy_delimiter)
        taxonomy = Spree::Taxonomy.find_or_create_by(name: taxonomy_name)
        taxon = taxon_names.reduce(taxonomy.root) do |parent_taxon, taxon_name|
          parent_taxon.children.find_or_create_by(name: taxon_name)
        end
        spree_product.taxons << taxon unless spree_product.taxons.include?(taxon)
      end
    end

    # TODO: Handle finding by SKU
    def find_spree_product(value_to_find)
      Spree::Variant.find_by(@key_to_match => value_to_find).try(:product)
    end

    def default_stock_location
      Spree::StockLocation.where(default: true).first ||
        Spree::StockLocation.all.select { |sl| sl.name.casecmp("default") }.first
    end
  end
end
