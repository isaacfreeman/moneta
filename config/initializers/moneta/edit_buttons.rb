# TODO: Only precompile if feature is active
Rails.application.config.assets.precompile += %w(moneta/edit_buttons/manifest.js moneta/edit_buttons/manifest.css)
