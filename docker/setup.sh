#!/bin/bash

set -e
set -x

cd
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export RBENV_ROOT=~/.rbenv' >> /etc/profile.d/rbenv.sh
echo 'export RBENV_ROOT=~/.rbenv' >> ~/.bashrc
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

bash -l -c 'rbenv install 2.2.1'
bash -l -c 'rbenv global 2.2.1'

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
bash -l -c  'gem install --no-rdoc --no-ri bundler'
bash -l -c  'gem install --no-rdoc --no-ri rails'
bash -l -c  'gem install --no-rdoc --no-ri sinatra'
bash -l -c  'gem install --no-rdoc --no-ri rspec'
bash -l -c  'gem install --no-rdoc --no-ri rack'
bash -l -c  'gem install --no-rdoc --no-ri capybara'