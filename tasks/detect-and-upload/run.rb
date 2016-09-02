#!/usr/bin/env ruby

require 'fileutils'

Dir.chdir('buildpack') do
  tag_to_add = "v#{File.read('VERSION')}"
  existing_tags = `git tag`.split("\n")

  if existing_tags.include? tag_to_add
    # do something smart
  else
    system(<<~EOF)
              export BUNDLE_GEMFILE=cf.Gemfile
              bundle config mirror.https://rubygems.org ${RUBYGEM_MIRROR}
              bundle install
              bundle exec buildpack-packager --uncached
              bundle exec buildpack-packager --cached
              EOF

    timestamp = `date +%s`.strip

    Dir["*.zip"].map do |filename|
      filename.match(/(.*)_buildpack(-cached)?-v(.*).zip/) do |match|
        language = match[1]
        cached = match[2]
        version = match[3]

        output_file = "../buildpack-artifacts/#{language}_buildpack#{cached}-v#{version}+#{timestamp}.zip"

        FileUtils.mv(filename, output_file)
      end
    end
  end
end

Dir.chdir('buildpack-artifacts') do
  Dir["*.zip"].each do |buildpack|
    md5sum = `md5sum #{buildpack}`
    sha256sum = `sha256sum #{buildpack}`
    puts "md5: #{md5sum}"
    puts "sha256: #{sha256sum}"
  end
end

#cd buildpack
#git tag v`cat VERSION`
#export BUNDLE_GEMFILE=cf.Gemfile
#bundle config mirror.https://rubygems.org ${RUBYGEM_MIRROR}
#bundle install
#bundle exec buildpack-packager --uncached
#bundle exec buildpack-packager --cached
#
#timestamp=$(date +%s)
#ruby <<RUBY
#require "fileutils"
#Dir.glob("*.zip").map do |filename|
#  filename.match(/(.*)_buildpack(-cached)?-v(.*).zip/) do |match|
#    language = match[1]
#    cached = match[2]
#    version = match[3]
#    FileUtils.mv(filename, "#{language}_buildpack#{cached}-v#{version}+$timestamp.zip")
#  end
#end
#RUBY
#
#cd ../buildpack-artifacts
#
#mv ../buildpack/*_buildpack-v*.zip .
#mv ../buildpack/*_buildpack-cached-v*.zip .
#
#echo md5: "`md5sum *_buildpack-v*.zip`"
#echo sha256: "`sha256sum *_buildpack-v*.zip`"
#echo md5: "`md5sum *_buildpack-cached-v*.zip`"
#echo sha256: "`sha256sum *_buildpack-cached-v*.zip`"
