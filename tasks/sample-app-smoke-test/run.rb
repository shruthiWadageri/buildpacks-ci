#!/usr/bin/env ruby

cf_api = ENV['CF_API']
cf_username = ENV['CF_USERNAME']
cf_password = ENV['CF_PASSWORD']
cf_organization = ENV['CF_ORGANIZATION']

if cf_api.nil? || cf_username.nil? || cf_password.nil? || cf_organization.nil?
  puts 'One of CF_API, CF_USERNAME, CF_PASSWORD, CF_ORGANIZATION is not set'
  exit 1
end

cf_login_command = "cf login -a #{cf_api} -u #{cf_username} -p #{cf_password} -o #{cf_organization}"
cf_login_output = `#{cf_login_command}`
puts cf_login_output

Dir.chdir('sample-app') do
  cf_push_output = `cf push --random-route`
  puts cf_push_output

  response = Net::HTTP.get_response('','/')
end
