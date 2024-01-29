source "https://rubygems.org"

ruby "3.2.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# Use postgresql as the database for Active Record
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# redis adapter for sidekiq
gem "redis", ">= 4.0.1"

# sidekiq for running background jobs
gem 'sidekiq', '~>6.4'
gem 'sidekiq-scheduler', '~>3.0'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  gem 'pry'
end

