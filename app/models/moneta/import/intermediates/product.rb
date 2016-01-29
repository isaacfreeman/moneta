module Moneta
  module Import
    module Intermediates
      # Intermediate product for importing/exporting
      class Product
        # TODO: Make separate constructors for different data sources, easy to override
        # TODO: document structure of @attributes
        def initialize(attributes, key_to_match = :name)
          @attributes = attributes
          @key_to_match = key_to_match
        end

        attr_reader :key_to_match

        def self.from_csv_attributes(attributes, key_to_match = :name)
          new(attributes, key_to_match = :name)
        end

        # Massage source product data into spree product data
        def to_spree_attributes
          {
            name: @attributes[:name],
            sku: @attributes[:sku],
            description: @attributes[:description],
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
            price: @attributes[:price],
            shipping_category: shipping_category(@attributes[:shipping_category_id])
          }
        end

        def name
          @attributes[:name]
        end

        private

        def shipping_category(shipping_category_id)
          Spree::ShippingCategory.find(shipping_category_id) || Spree::ShippingCategory.find_or_create_by(name: "Default")
        end
      end
    end
  end
end
