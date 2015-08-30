# About
Boilerplate for a RESTful JSON rails-api using Postgres.  The goal is to create a template for most APIs such that only the domain specific models & logic need to be added.  It also acts as a minimum deployable system if you use AWS.

## What's Added
* Rspec preconfigured w/ FactoryGirl.
* Rspec integration tests for User Registration, Confirmation, Login, & Logout.
* API Versioning via requests, aka, 'api/v1/...' & ability to specify version in request headers if enabled.
* Added functionality such that logging out invalidates an auth token.
* Provided Dockerfile for easy developer setup and deployment.
* Provided scripts, configuration files, and instructions for deployment to [AWS ElasticBeanstalk](https://aws.amazon.com/elasticbeanstalk/)

## Thanks
Made from the following tutorials: <https://github.com/thoulike/rails-api-authentication-token-example>,<http://apionrails.icalialabs.com/book/chapter_two>. Thanks!

## Status
![](https://codeship.com/projects/af873400-1b80-0133-1262-5e80c3fb6dd5/status?branch=master)

## Authentication Procedure
Users are required to register and confirm their email address.  Once registered, upon login they receive a token that can be sent in the headers of future requests for authorization.  Once issued, the token does not change.  A new token is generated on sign out and can be obtained by signing in again.  See `spec/requests/users_spec.rb` for details.

Use your favorite [HTTP Client](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop) to generate the following requests:

### User Registration
```
  POST /api/v1/users HTTP/1.1
  Host: 192.168.99.100:8080
  Content-Type: application/json
  Cache-Control: no-cache

  { "user" : { "email" : "myemail@gmail.com", "password" : "mybadpassword" }}
```

### User Confirmation
Depending on how you have configured email deliveries, you should get an email with a confirmation link.  By default, the email is printed in the server logs.

The link should look like the following:
`http://192.168.99.100:8080/api/v1/users/confirmation?confirmation_token=ZxvbZx3smFTFnFjm8AYA`

### User Sign In
```
  POST /api/v1/users/sign_in HTTP/1.1
  Host: 192.168.99.100:8080
  Content-Type: application/json
  Cache-Control: no-cache

  { "user" : { "email" : "myemail@gmail.com", "password" : "mybadpassword" }}
```

This will return an `authentication_token` which you will set as the `X-User-Token` header in future requests.

### Example Authenticated Request
```
  GET /api/v1/example HTTP/1.1
  Host: 192.168.99.100:8080
  Content-Type: application/json
  X-User-Token: fXue2vifDPbxJ1v-n3c1
  X-User-Email: myemail@gmail.com
  Cache-Control: no-cache
```

# Starting a new fork
1. Update `APP_NAME` in `config/application.rb` to your project name. Don't forget to change the module name too.
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
1. Test with `curl localhost:3000/api/v1/example`. You should get a 'You need to sign in' response.

# Postgres 9.2 Mac OSX Install
1. Install homebrew `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
1. `brew install postgres`
1. First time db initialization `initdb /usr/local/var/postgres -E utf8`
1. Start Postgres `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`

# Configuring Continuous Integration with Codeship
1. Start an account with <https://codeship.com>, create a project and link it to your github/bitbucket account.
1. Add `./scripts/setup_test.sh` as a test setup command.
1. Add `bundle exec rspec` as the test pipeline command.
1. Push to your configured branch to run CI tests!

# Configuring Continuous Deployment with Codeship and AWS Elastic Beanstalk

### Setting up AWS EB
1. Create a new AWS Access Key. See [documentation](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html). *NOTE:* You'll need these credentials later to configure Codeship.
1. Create a 'User Policy' for the User created in the previous step.  Creating a custom inline policy is likely the easiest.  Set the policy to the [following](.aws/codeship_permissions.json). *NOTE:* These permissions will work but are too permissive and should be narrowed to only apply to the necessary resources ASAP.  PRs welcome to improve the example policy.
1. Create a new AWS Elastic Beanstalk application: select a name, select 'Create web server', select Generic 'Docker' platform, select 'single instance', select 'Sample Application', make up a environment name, select 'create RDS DB Instance'.
1. Make an EC2 key pair if you haven't already. See [documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair).  Refresh key pair list if necessary and select your key pair. Leave other options as default.
1. Skip making Environment tags.
1. Select postgres as DB engine for RDS Configuration, create secure username and password for you database. Leave other options as default.
1. Select aws-elasticbeanstalk-ec2-role as your instance profile.  Allow creating a new aws-elasticbeanstalk-service-role.
1. Launch your application.  You can continue configuration while you wait for it to launch.
1. Select 'Configuration', select 'Software Configuration', add the following environment variables from [database.yml](config/database.yml) with their correct values.
1. Note that this [script](.ebextensions/02.migrations.config) is used automatically by AWS EB to run migrations on deployment.  You can add your own scripts too.

### Setting up Codeship
1. Setup CI with CodeShip (see section above)
1. Create a branch for deployment. i.e. `git checkout -b deploy`
1. Setup a deployment pipeline in Codeship, and select Amazon Elastic Beanstalk.
1. Create an S3 bucket if you don't already have one, make a directory to store your builds, and set the path on the Codeship configuration page.  i.e. `mybucketname/my-boilerplate-rails-api-json-directory`. See [documentation](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html). *NOTE:* Make sure your S3 instance is under the same region as your Elastic Beanstalk service!
1. Copy AWS access key info from the `Setting up AWS EB` section to the Codeship config page.
1. Fill out the rest of the config page and submit.
1. Push to your configured branch, your app should deploy.  Check the Codeship and AWS EB dashboard for error messages. *NOTE:* I've had issues with non-descriptive error messages on initial deploys.  However, I resolved this by manually uploading the .zip file created by Codeship (and saved on your configured S3 bucket) directly to the AWS EB application using the AWS Web GUI. Afterward, Codeship deploys successfully from then on.

# Syncing after forking
The expectation is that you'll fork this template to make your own project and will potentially need to sync using the following procedure: <https://help.github.com/articles/syncing-a-fork/>
