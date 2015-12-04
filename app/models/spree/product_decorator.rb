Spree::Product.class_eval do
  include Moneta::AlgoliaSearch::Product if feature_active?(:algolia_search)
end
