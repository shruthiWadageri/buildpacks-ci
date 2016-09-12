#!/usr/bin/env ruby

require 'net/http'
require 'json'

def delete_space(space)
  cf_delete_space_command = "cf delete-space #{space} -f"
  cf_delete_space_output = `#{cf_delete_space_command}`
  puts cf_delete_space_output
end

cf_api = ENV['CF_API']
cf_username = ENV['CF_USERNAME']
cf_password = ENV['CF_PASSWORD']
cf_organization = ENV['CF_ORGANIZATION']
cf_domain = ENV['CF_DOMAIN']
cf_login_space = ENV ['CF_LOGIN_SPACE']
cf_app_space = "sample-app-#{Random.rand(100000)}"
app_name = ENV['APPLICATION_NAME']
buildpack_url = ENV['BUILDPACK_URL']
path_to_get = ENV['PATH_TO_GET']

if cf_api.nil? || cf_username.nil? || cf_password.nil? || cf_organization.nil?
  puts 'One of CF_API, CF_USERNAME, CF_PASSWORD, CF_ORGANIZATION is not set'
  exit 1
end

cf_login_command = "cf login -a #{cf_api} -u #{cf_username} -p #{cf_password} -o #{cf_organization} -s #{cf_login_space}"
cf_login_output = `#{cf_login_command}`
puts cf_login_output


cf_create_space_command = "cf create-space #{cf_app_space}"
cf_create_space_output = `#{cf_create_space_command}`
puts cf_create_space_output

cf_target_command = "cf target -o #{cf_organization} -s #{cf_app_space}"
cf_target_output = `#{cf_target_command}`
puts cf_target_output

Dir.chdir('sample-app') do
  cf_push_output = `cf push -b #{buildpack_url} --random-route`
  puts cf_push_output

  if app_name == 'sailspong'
    puts `cf create-service cleardb spark mysql`
  end
end

apps = JSON.parse(`cf_curl '/v2/apps' -X GET -H 'Content-Type: application/x-www-form-urlencoded' -d 'q=name:#{app_name}'`)
routes_url = apps['resources'].first['entity']['routes_url']

routes = JSON.parse(`cf curl #{routes_url}`)
host = routes['resources'].first['entity']['host']

response = Net::HTTP.get_response("#{host}.#{cf_domain}",path_to_get)

if response.code == "200"
  puts 'Got HTTP response 200. App push successful'
  delete_space(cf_app_space)
else
  puts "Got HTTP response #{response.code}. App push unsuccessful"
  delete_space(cf_app_space)
  exit 1
end
