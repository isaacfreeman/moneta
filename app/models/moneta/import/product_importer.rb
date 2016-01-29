module Moneta
  module Import
    # Process a hash of product attributes and create or update a product
    class ProductImporter
      def initialize(attributes, key_to_match = :name)
        @product = Intermediates::Product.from_csv_attributes(attributes)
        @key_to_match = key_to_match
      end

      def import
        # TODO: use key_to_match instead of hard coded name
        value_to_find = @product.name
        spree_product = find_spree_product(value_to_find)
        spree_attributes = @product.to_spree_attributes
        if spree_product.present?
          puts "Updating existing product: #{@product.name}"
          spree_product.update_attributes(spree_attributes)
        else
          puts "Creating new product: #{@product.name}"
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
