module Moneta
  module Import
    # Process a hash of product attributes and create or update a product
    class ProductImporter
      def initialize(attributes, key_to_match = :name)
        @source_product = Intermediate::Product.from_csv_attributes(attributes)
        @key_to_match = key_to_match
      end

      def import
        value_to_find = @source_product.key_to_match
        spree_product = find_spree_product(value_to_find)
        spree_attributes = @source_product.to_spree_attributes
        if spree_product.present?
          puts "Updating existing product: #{value_to_find}"
          spree_product.update_attributes(spree_attributes)
        else
          puts "Creating new product: #{value_to_find}"
          Spree::Product.create(spree_attributes)
        end
      end

      private

      def find_spree_product(value_to_find)
        Spree::Product.find_by(@key_to_match => value_to_find)
      end
    end
  end
end
