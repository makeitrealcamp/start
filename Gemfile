source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.7'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21.0'
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
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'gravatar-ultimate'
gem 'ranked-model'
gem 'paper_trail', github: 'germanescobar/paper_trail'
gem 'redcarpet'
gem 'pygments.rb'
gem 'friendly_id', '~> 5.1.0'
gem 'sidekiq'
gem 'hstore_accessor'
gem 'octokit'
gem 'gendered'
gem 'subprocess'
gem 'will_paginate'
gem 'table_print'
gem 'momentjs-rails'

gem 'omniauth-slack'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.3'
gem 'nested_form_fields'
gem 'annotate'

#windows specific
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# Use Unicorn as the app server
gem 'unicorn', platforms: [:ruby]

gem 'zeroclipboard-rails'
gem 'shareable', github: "simon0191/shareable"
gem 'virtus'
gem 'pusher'
gem 'roadie-rails', '~> 1.3'
gem 'figaro'
gem 'remote_syslog_logger'
gem 'date_supercharger'
gem 'json-schema'
gem 'simple_timeout'
gem 'gretel'
gem 'convertloop', '0.1.2'
gem 'httparty'
gem 'lograge', '~> 0.10.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails', '~> 3.5.2'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.4.3'
end

group :development do
  gem 'letter_opener'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.7'
end

group :test do
  gem 'shoulda-matchers', '2.8.0', require: false
  gem 'capybara', '~> 2.7', '>= 2.7.1'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver', '3.0.0'
  gem 'chromedriver-helper'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rspec-wait', '0.0.9'
  gem 'rspec-retry', '0.5.2'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.2'
end
