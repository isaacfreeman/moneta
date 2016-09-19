module Import
  module Intermediates
    # Intermediate variant for importing/exporting
    # TODO: Document structure of @attributes for future from_ methods that
    #       handle other data sources
    class Variant
      def initialize(attributes, options = {})
        @key_to_match = options[:key_to_match] || :sku
        @item_delimiter = options[:item_delimiter] || ","
        @key_delimiter = options[:key_delimiter] || ":"
        @attributes = attributes
      end

      attr_reader :key_to_match

      def self.from_csv_attributes(attributes, options = {})
        new(attributes, options)
      end

      # Massage source product data into spree product data
      # If we're updating an existing product, we need it as an argument, so we
      # can find associated properties etc.
      def to_spree_attributes(spree_product = nil)
        {
          product_id: spree_product.try(:id),
          sku: @attributes[:sku].to_s,
          price: @attributes[:price],
          cost_price: @attributes[:cost_price],
          width: @attributes[:width],
          height: @attributes[:height],
          depth: @attributes[:depth],
          weight: @attributes[:weight],
          is_master: false,
          options: options_array
        }
      end

      def sku
        @attributes[:sku].to_s
      end

      def image_urls
        @attributes[:images].try(:split, ",")
      end

      def stock
        @attributes[:stock]
      end

      def product_sku
        @attributes[:product_sku].to_s
      end

      private

      def options_array
        return [] if @attributes[:options].blank?
        option_strings = @attributes[:options].split(",")
        option_strings.map do |os|
          name, value = os.split(":")
          { name: name, value: value }
        end
      end
    end
  end
end
