module Moneta
  module AlgoliaSearch
    # Index products in Algolia when images are updated
    module Image
      extend ActiveSupport::Concern

      included do
        after_save :algolia_index!
      end

      def algolia_index!
        viewable.algolia_index! if viewable.present?
      end
    end
  end
end
