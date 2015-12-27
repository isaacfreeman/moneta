module Moneta
  # Process a hash of product attributes and create or update a product
  class ProductImporter
    def initialize(attributes, key_to_match = :name)
      @source_product = OpenStruct.new(attributes)
      @key_to_match = key_to_match
    end

    def import
      value_to_find = @source_product.send(@key_to_match)
      spree_product = find_product(value_to_find)
      if spree_product.present?
        puts "Updating existing product: #{value_to_find}"
        spree_product.update_attributes(
          spree_product_attributes(@source_product, spree_product)
        )
      else
        puts "Creating new product: #{value_to_find}"
        spree_product = Spree::Product.create(
          spree_product_attributes(@source_product)
        )
      end

      # if product.valid?
      #   puts "Valid product: #{product.inspect}"
      #   product.save
      # else
      #   puts "Invalid product: #{product.inspect} #{product.errors.messages}"
      # end
    end

    private

    # massage source product data into spree product data
    # TODO: make this accessible as a class, with constructors from different sources
    def spree_product_attributes(source_product, spree_product=nil)
      shipping_category = Spree::ShippingCategory.find(source_product.shipping_category_id) || default_shipping_category
      {
        name: source_product.name,
        sku: source_product.sku,
        description: source_product.description,
        # variants: source_product.variants.map{ |variant|
        #   {
        #     name: variant.name,
        #     count_on_hand: variant.stock_on_hand,
        #     sku: variant.sku,
        #     price: StagingVariant.wholesale_price_from(variant),
        #     options: options_array(source_product, variant),
        #     is_master: false
        #   }
        # },
        # product_properties_attributes: [
        #   product_property_attributes(
        #     "producer_id",
        #     source_product.store_id,
        #     spree_product
        #   ),
        #   product_property_attributes(
        #     "source_id",
        #     source_product.id,
        #     spree_product
        #   )
        # ],
        price: source_product.price,
        shipping_category: shipping_category
      }
    end

    def find_product(value_to_find)
      Spree::Product.find_by(@key_to_match => value_to_find)
    end

    def default_shipping_category
      Spree::ShippingCategory.find_or_create_by(name: "Default")
    end
  end
end
