#!/usr/bin/env ruby

require 'yaml'

DEFAULT_CONFIG_PATH = "config/database.yml"

db_config_path = ARGV[0]
db_config_path = DEFAULT_CONFIG_PATH if db_config_path.nil?

db_config = YAML.load_file(db_config_path)
db_config.each do |env, config|
  user = config['username']
  pass = config['password']
  db = config['database']
  puts "For user '#{user}', set password to '#{pass}', if already created, then just hit enter and ignore prompt."
  puts `createuser -d -P #{user}`

  puts "Creating database '#{db}'"
  puts `createdb --owner=#{user} #{config['database']}`
end
