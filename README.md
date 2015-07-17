# About
Boilerplate for a RESTful JSON rails-api using Postgres

# Getting started
1. Update `APP_NAME` in `config/application.rb` to your project name.
1. Execute `init_rvm.rb <PROJECT_NAME>` to create rvm files
1. Update `config/database.yml` with desired settings.
1. Install postgres (see instructions below)
1. Create users and databases using `./init_pg_db.rb` (it uses database.yml)

# Postgres 9.2 Mac OSX Install
1. Install homebrew `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
1. `brew install postgres`
1. First time db initialization `initdb /usr/local/var/postgres -E utf8`
1. Start Postgres `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`
