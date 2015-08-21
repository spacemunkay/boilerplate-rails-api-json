rvm use 2.2.2 --install
bundle install
export RAILS_ENV=test
bundle exec rake db:schema:load
bundle exec rake db:migrate
bundle exec rake db:test:prepare
