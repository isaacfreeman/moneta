module Moneta
  module AlgoliaSearch
    # Index products in Algolia when stock levels are updated
    module StockItem
      extend ActiveSupport::Concern

      included do
        after_save :algolia_index!
        after_destroy :algolia_index!
      end

      def algolia_index!
        variant.try(:product).index!
      end
    end
  end
end
