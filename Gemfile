source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1.0'
# Use Unicorn as the app server
gem 'unicorn', platforms: [:ruby]
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# User Bootstrap
gem 'bootstrap-sass', '~> 3.4.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.9.3', require: false

gem 'gravatar-ultimate'
gem 'ranked-model'
gem 'paper_trail', '~>10.0'
gem 'redcarpet'
gem 'pygments.rb', '~> 2.2'
gem 'friendly_id', '~> 5.5.0'
gem 'sidekiq', '~> 6.2'
gem 'hstore_accessor'
gem 'octokit'
gem 'gendered'
gem 'subprocess'
gem 'will_paginate'
gem 'table_print'
gem 'momentjs-rails'
gem 'omniauth-slack', '~> 2.3.0'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.3'
gem 'nested_form_fields'
gem 'zeroclipboard-rails'
gem 'shareable', github: "simon0191/shareable"
gem 'virtus'
gem 'pusher'
gem 'roadie-rails', '~> 2.0'
gem 'figaro'
gem 'remote_syslog_logger'
gem 'date_supercharger'
gem 'json-schema'
gem 'simple_timeout'
gem 'gretel'
gem 'convertloop', '0.1.2'
gem 'httparty'
gem 'lograge', '~> 0.10.0'
gem 'xmlrpc'
gem 'aws-sdk-s3', '~> 1.67', '>= 1.67.1'
gem 'image_processing', '~> 1.11'
gem 'icalendar', '~> 2.6', '>= 2.6.1'
gem 'split', '~> 4.0', '>= 4.0.1'
gem 'stripe', '~> 7.1'
gem 'rack-cors', '~> 1.1'
gem 'webrick', '~> 1.8'
gem 'rexml', '~> 3.2'
gem 'psych', '< 4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 2.23.0'
end

group :development do
  gem 'letter_opener', '~> 1.7.0'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.1.0'
  gem 'annotate', '~>3.1.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails_server_timings', '~> 1.0', '>= 1.0.8'
end

group :test do
  gem 'shoulda-matchers', '4.1.0', require: false
  gem 'capybara', '>= 3.33'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver', '3.142.7'
  gem 'webdrivers', '~> 3.9'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rspec-wait', '0.0.9'
  gem 'rspec-retry', '0.5.2'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.2'
end

#windows specific
gem 'tzinfo-data', platforms: [:mingw, :mswin]
