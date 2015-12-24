# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# TODO: Only precompile if :algolia_search feature is active
Rails.application.config.assets.precompile += %w( moneta/algolia_search/manifest.js )
Rails.application.config.assets.precompile += %w( moneta/edit_buttons/manifest.js moneta/edit_buttons/manifest.css )
Rails.application.config.assets.precompile += %w( moneta/menus/manifest.js moneta/menus/manifest.css )
