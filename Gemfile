source 'https://rubygems.org'

gem 'bundler', '>= 1.7.0'

ruby '2.1.6'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Environment variable management. Read more under https://github.com/bkeepers/dotenv#usage
gem 'dotenv-rails', :groups => [:development, :test]

# ActsAsTaggableOn, tags support 
gem 'acts-as-taggable-on', '~> 3.4'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Gravatar profile pictures
gem 'gravtastic'

# Devise (authentication)
gem 'devise'

# Pundit (authorization)
gem 'pundit'

# Dropbox
gem 'dropbox-sdk'

# RestClient
gem 'rest-client'

# Geocoding (find lat/lng by adress)
gem 'geocoder'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-turbolinks'


# Kaminari, pageinate 
gem 'kaminari'

source 'https://rails-assets.org' do
  # Only jQuery should be included as extra gem, any other JS library should be included from rails-assets
  gem 'rails-assets-leaflet'
  gem 'rails-assets-leaflet.markercluster'
  gem 'rails-assets-Leaflet.awesome-markers'
  gem 'rails-assets-bootstrap-vertical-tabs'
end

# Use puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'capybara'
  # FactoryGirl
  gem 'factory_girl_rails'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'railroady'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'email_spec'
end

# Heroku
# - We have to use postgres instead of sqlite (not supported on heroku), therefore we've to use a different environment group
group :production do
  gem 'pg'
  gem 'rails_12factor'
end
