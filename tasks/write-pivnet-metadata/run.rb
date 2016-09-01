#!/usr/bin/env ruby

require_relative 'pivnet-metadata-writer'

root_dir      = Dir.pwd
metadata_dir  = File.join(root_dir, 'pivnet-dotnet-core-metadata', 'pivnet-metadata')
buildpack_dir = File.join(root_dir, 'buildpack-master')

buildpack_files = Dir["pivotal-buildpack-cached/dotnet-core_buildpack-cached-v*.zip"]

if buildpack_files.count != 1
  puts "Expected 1 cached buildpack file, found #{buildpack_files.count}:"
  puts buildpack_files
  exit 1
else
  cached_buildpack_filename = buildpack_files.first

  writer = PivnetMetadataWriter.new(metadata_dir, buildpack_dir, cached_buildpack_filename)
  writer.run!

  system("rsync -a pivnet-dotnet-core-metadata/ pivnet-dotnet-core-metadata-artifacts")
end
