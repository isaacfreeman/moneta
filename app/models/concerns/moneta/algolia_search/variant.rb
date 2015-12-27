module Moneta
  module AlgoliaSearch
    # Index products in Algolia when variants are updated
    module Variant
      extend ActiveSupport::Concern

      included do
        after_save :algolia_index!
      end

      def algolia_index!
        # return if we're in the middle of building a master for a new product
        # (in that case, we don't yet have the data for Algolia)
        return unless product && product.master.present?
        product.algolia_index!
      end

      def to_algolia_hash
        {
          'sku' => sku,
          'title' => title,
          'name' => product.name,
          'options' => options_text,
          'disabled' => !in_stock?,
          'stock_on_hand' => total_on_hand.to_s,
          'id' => id,
          'price' => display_price.to_s
        }
      end

      private

      def title
        option_list_text = options_list.present? ? " (#{options_text})" : ''
        "#{product.name}#{option_list_text}"
      end
    end
  end
end
