# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Although this is not needed for an api-only application, rails4
# requires secret_key_base or secret_token to be defined, otherwise an
# error is raised.
# Using secret_token for rails3 compatibility. Change to secret_key_base
# to avoid deprecation warning.
# Can be safely removed in a rails3 api-only application.
APP_MODULE::Application.config.secret_token = ENV['RAILS_SECRET_TOKEN'] || '22f2e725057a10d5bce40a41ae119dc490726da67b1c40ab701feca6043cb5e20ada18ab13add1d42c76907bd5a50015ce91dde0efcf015c5327b222658dc901'
