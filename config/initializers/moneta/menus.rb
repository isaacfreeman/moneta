# TODO: Only precompile if feature is active
Rails.application.config.assets.precompile += %w(moneta/menus/manifest.js moneta/menus/manifest.css)
