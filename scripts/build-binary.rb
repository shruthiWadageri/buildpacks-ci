#!/usr/bin/env ruby
# encoding: utf-8

buildpacks_ci_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
binary_builder_dir = File.join(buildpacks_ci_dir, 'binary-builder')

require "#{buildpacks_ci_dir}/lib/concourse-binary-builder"

ConcourseBinaryBuilder.new(ENV['BINARY_NAME'], buildpacks_ci_dir, binary_builder_dir, ENV['GIT_SSH_KEY']).run
