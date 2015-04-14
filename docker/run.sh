# clone app
git clone $1 /app

cd /app
bundle install --path=/ukku/bundler-cache
rake db:migrate

# run template
rake rails:template LOCATION=/ukku/data/rails_template.rb
bundle install --path=/ukku/bundler-cache

# setup spec
if [ -d "spec" ]; then
  rm -rf spec
fi

bundle exec rails generate rspec:install
cp /ukku/data/makeitreal_spec.rb spec/

bundle exec rspec spec --format j --fail-fast --out /ukku/data/result.json