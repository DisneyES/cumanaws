# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Enable the asset pipeline
Rails.application.config.assets.enabled = true

# Speed up precompile by not loading the environment
Rails.application.config.assets.initialize_on_precompile = false

# Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
Rails.application.config.assets.precompile += %w{
      form.js
      jquery.slides.min.js

      grid.css
      form.css
}
    
Rails.application.config.assets.js_compressor = :uglify