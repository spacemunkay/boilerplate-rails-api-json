#!/usr/bin/env ruby

DEFAULT_RUBY_VERSION = "2.2.2"

project_name = ARGV[0]
ruby_version = ARGV[1]
raise "Provide a project name! Example '#{__FILE__} my-project-name'" if project_name.nil?

ruby_version = DEFAULT_RUBY_VERSION if ruby_version.nil?
puts "Using ruby version: #{ruby_version} for #{project_name}"

File.open('.ruby-gemset', 'w+') { |f| f.write project_name }
File.open('.ruby-version', 'w+') { |f| f.write ruby_version }
