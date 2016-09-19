# TODO: Only precompile if feature is active
Rails.application.config.assets.precompile += %w(moneta/option_selection/manifest.js moneta/option_selection/manifest.css)
