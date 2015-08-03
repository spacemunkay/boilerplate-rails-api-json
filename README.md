# About
Boilerplate for a RESTful JSON rails-api using Postgres.  The goal is to create a template for most APIs such that only the domain specific models & logic need to be added.

## Authentication Procedure
Users are required to register and confirm their email address.  Once registered, upon login they receive a token that can be sent in the headers of future requests for authorization.  Once issued, the token does not change, however I plan on adding the ability for a user to renew their token.  See `spec/requests/users_spec.rb` for details.

## What's Added
* Rspec preconfigured w/ FactoryGirl.
* Rspec integration tests for User Registration, Confirmation, Login, & Logout.
* API Versioning via requests, aka, 'api/v1/...' & ability to specify version in request headers if enabled.
* Added functionality such that logging out invalidates an auth token.
* Yea, it's not too much yet, but every bit counts.

## Thanks
Made from the following tutorials: <https://github.com/thoulike/rails-api-authentication-token-example>,<http://apionrails.icalialabs.com/book/chapter_two>. Thanks!

## Status
![](https://codeship.com/projects/af873400-1b80-0133-1262-5e80c3fb6dd5/status?branch=master)

# Getting started
1. Update `APP_NAME` in `config/application.rb` to your project name.
1. Execute `init_rvm.rb <PROJECT_NAME>` to create rvm files
1. Update `config/database.yml` with desired settings. (Defaulted to Docker Compose configuration)

# Running with Docker (recommended)
1. These instructions haven't been tests, please provide corrections!
1. For Mac & Windows install Boot2docker <http://boot2docker.io/>
1. If not installed with Boot2docker, install Docker <https://docs.docker.com/installation/>
1. Install Docker Compose <https://docs.docker.com/compose/install/>
1. Execute `docker-compose run web rake db:migrate`
1. Execute `docker-compose build`
1. Execute `docker-compose up`
1. If using Boot2docker, execute `boot2docker ip` to get the IP to use when making requests to the Rails server.
1. Test the Rails server is running with `curl $(boot2docker ip):8080/api/v1/example`

# Running locally
1. Install postgres (see instructions below)
1. Create users and databases using `./init_pg_db.rb` (it uses database.yml)

# Postgres 9.2 Mac OSX Install
1. Install homebrew `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
1. `brew install postgres`
1. First time db initialization `initdb /usr/local/var/postgres -E utf8`
1. Start Postgres `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`

