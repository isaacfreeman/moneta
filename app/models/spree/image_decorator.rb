Spree::Image.class_eval do
  include Moneta::AlgoliaSearch::Image if feature_active?(:algolia_search)
end
