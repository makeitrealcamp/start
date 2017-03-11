gem_group :test do
  gem 'rspec-rails', '~> 3.5.2'
  gem 'shoulda-matchers', github: 'germanescobar/shoulda-matchers'
  gem 'capybara', '~> 2.12.1'
  gem "selenium-webdriver", '~>2.45.0'
  gem 'phantomjs', github: 'germanescobar/phantomjs-gem', require: 'phantomjs/poltergeist'
end
