gem_group :test do
  gem 'rspec-rails', '~> 4.1.2'
  gem 'shoulda-matchers', '3.1.3'
  gem 'net-smtp', require: false
  gem 'net-imap', require: false
  gem 'net-pop', require: false
  if Gem::Specification.find_all_by_name("capybara").empty?
    gem 'capybara', '~> 2.12.1'
  end
  if Gem::Specification.find_all_by_name("selenium-webdriver").empty?
    gem "selenium-webdriver", '~>2.45.0'
  end
  gem 'poltergeist'
  gem 'phantomjs', '2.1.1.0', require: 'phantomjs/poltergeist'
end
