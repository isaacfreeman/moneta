Spree::StockItem.class_eval do
  include Moneta::AlgoliaSearch::StockItem if feature_active?(:algolia_search)
end
