module Moneta::AlgoliaSearch::Variant
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
end
