Spree::Product.class_eval do
  include Moneta::AlgoliaSearch::Product
end
