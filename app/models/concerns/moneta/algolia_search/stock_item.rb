module Moneta::AlgoliaSearch::StockItem
  extend ActiveSupport::Concern

  included do
    after_save :algolia_index!
    after_destroy :algolia_index!
  end

  def algolia_index!
    variant.try(:product).index!
  end
end
