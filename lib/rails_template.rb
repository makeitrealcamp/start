gem_group :test do
  gem 'rspec-rails', '~> 3.5.2'
  gem 'shoulda-matchers', github: 'germanescobar/shoulda-matchers'
  if Gem::Specification.find_all_by_name("capybara").empty?
    gem 'capybara', '~> 2.12.1'
  end
  if Gem::Specification.find_all_by_name("selenium-webdriver").empty?
    gem "selenium-webdriver", '~>2.45.0'
  end
  gem 'poltergeist'
  gem 'phantomjs', github: 'germanescobar/phantomjs-gem', require: 'phantomjs/poltergeist'
end
