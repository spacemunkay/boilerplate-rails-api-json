# About
Boilerplate for a RESTful JSON rails-api using Postgres.  The goal is to create a template for most APIs such that only the domain specific models & logic need to be added.

## Authentication Procedure
Users are required to register and confirm their email address.  Once registered, upon login they receive a token that can be sent in the headers of future requests for authorization.  Once issued, the token does not change, however I plan on adding the ability for a user to renew their token.  See `spec/requests/users_spec.rb` for details.

## What's Added
* Rspec preconfigured w/ FactoryGirl.
* Rspec integration tests for User Registration, Confirmation, Login, & Logout.
* API Versioning via requests, aka, 'api/v1/...' & ability to specify version in request headers if enabled.
* Added functionality such that logging out invalidates an auth token.
* Provided Dockerfile for easy developer setup and deployment.
* Provided scripts and configuration files for deployment to [AWS ElasticBeanstalk](https://aws.amazon.com/elasticbeanstalk/)

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
1. For Mac & Windows install Docker Toolbox <https://www.docker.com/toolbox>  (or Boot2docker <http://boot2docker.io/>)
1. If not installed with Docker Toolbox or Boot2docker, install Docker <https://docs.docker.com/installation/>
1. If not installed with Docker Toolbox, then install Docker Compose <https://docs.docker.com/compose/install/>
1. Execute `docker-compose run web rake db:migrate`
1. Execute `docker-compose build`
1. Execute `docker-compose up`
1. If using Docker Toolbox, use `docker-machine ip default` to get the IP.  If using Boot2docker, execute `boot2docker ip` to get the IP to use when making requests to the Rails server.
1. Test the Rails server is running with `curl <INSERT IP>:8080/api/v1/example`.  You should get `{"error":"You need to sign in or sign up before continuing."}` as a response.

# Running locally
1. Install postgres (see instructions below)
1. Create users and databases using `./init_pg_db.rb` (it uses database.yml)
1. Run `bundle exec rake db:create db:migrate`
1. Run `bundle exec rails s`
1. Test with `curl localhost:3000/api/v1/example`. You should get a 'You need to sign in response'.

# Postgres 9.2 Mac OSX Install
1. Install homebrew `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
1. `brew install postgres`
1. First time db initialization `initdb /usr/local/var/postgres -E utf8`
1. Start Postgres `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`

# Configuring Continuous Integration with Codeship
1. Start an account with <https://codeship.com>, create a project and link it to your github/bitbucket account.
1. Add `./scripts/setup_test.sh` as a test setup command.
1. Push to your configured branch to run CI tests!

# Configuring with Codeship and AWS Elastic Beanstalk
1. TBD

# Syncing after forking
The expectation is that you'll fork this template to make your own project and will potentially need to sync using the following procedure: <https://help.github.com/articles/syncing-a-fork/>
