# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

gem "sidekiq", "~> 7.3"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1", ">= 3.1.12"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem "jwt", "~> 1.5", ">= 1.5.4"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails", "~> 6.4", ">= 6.4.3"
  gem "pry-byebug", "~> 3.10", ">= 3.10.1"
  gem "rspec-rails", "~> 6.1", ">= 6.1.3"
end

group :development do
  gem "bullet", "~> 7.1"
  gem "rubocop", "~> 1.64"
  gem "rubocop-rails", "~> 2.25"
  gem "rubocop-rspec", "~> 3.0"
end

group :test do
  gem "rspec-sidekiq", "~> 5.0"
  gem "shoulda-matchers", "~> 6.2"
end
