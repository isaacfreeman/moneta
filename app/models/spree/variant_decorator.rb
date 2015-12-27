Spree::Variant.class_eval do
  include Moneta::AlgoliaSearch::Variant if feature_active?(:algolia_search)
end
