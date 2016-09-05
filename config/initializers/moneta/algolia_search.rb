# Algolia index to store product search information in
Rails.application.config.algolia_index = ENV["ALGOLIA_INDEX"]

AlgoliaSearch.configuration = {
  application_id: ENV["ALGOLIA_APPLICATION_ID"],
  api_key: ENV["ALGOLIA_ADMIN_API_KEY"],
  pagination_backend: :kaminari
}

Rails.application.config.assets.precompile += %w(moneta/algolia_search/manifest.js)
