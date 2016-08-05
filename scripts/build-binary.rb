#!/usr/bin/env ruby
# encoding: utf-8

buildpacks_ci_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require "#{buildpacks_ci_dir}/lib/build-binary"

ConcourseBinaryBuilder.new(ENV['BINARY_NAME'], ENV['GIT_SSH_KEY']).run
