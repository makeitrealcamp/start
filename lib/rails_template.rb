gem_group :test do
  gem 'rspec-rails', '~> 3.2.1'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'capybara', '~> 2.4.4'
  gem 'poltergeist', '~> 1.6.0'
  gem 'phantomjs', github: 'germanescobar/phantomjs-gem', require: 'phantomjs/poltergeist'
end