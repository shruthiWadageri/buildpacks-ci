#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'json'

def delete_space(space)
  puts `cf delete-space #{space} -f`
end

def target_cf(cf_api, cf_username, cf_password, cf_organization, cf_login_space, cf_app_space)
  puts `cf login -a #{cf_api} -u #{cf_username} -p #{cf_password} -o #{cf_organization} -s #{cf_login_space}`

  puts `cf create-space #{cf_app_space}`

  puts `cf target -o #{cf_organization} -s #{cf_app_space}`
end

def push_app(buildpack_url)
  Dir.chdir('sample-app') do
    puts `cf push -b #{buildpack_url} --random-route`
  end
end

def get_app_route_host(app_name)
  apps = JSON.parse(`cf curl '/v2/apps' -X GET -H 'Content-Type: application/x-www-form-urlencoded' -d 'q=name:#{app_name}'`)
  routes_url = apps['resources'].first['entity']['routes_url']

  routes = JSON.parse(`cf curl #{routes_url}`)
  routes['resources'].first['entity']['host']
end

cf_api = ENV['CF_API']
cf_username = ENV['CF_USERNAME']
cf_password = ENV['CF_PASSWORD']
cf_organization = ENV['CF_ORGANIZATION']
cf_domain = ENV['CF_DOMAIN']
cf_login_space = ENV['CF_LOGIN_SPACE']
app_name = ENV['APPLICATION_NAME']
buildpack_url = ENV['BUILDPACK_URL']
path_to_get = ENV['PATH_TO_GET']
bind_mysql = ENV['BIND_MYSQL']
cf_app_space = "sample-app-#{Random.rand(100000)}"

env_vars = %w(CF_API CF_USERNAME CF_PASSWORD CF_ORGANIZATION CF_DOMAIN CF_LOGIN_SPACE APPLICATION_NAME BUILDPACK_URL PATH_TO_GET BIND_MYSQL)

env_vars.each do |var|
  if ENV[var].nil?
    puts "#{var} is not set. Exiting..."
    exit 1
  end
end

target_cf(cf_api, cf_username, cf_password, cf_organization, cf_login_space, cf_app_space)

if bind_mysql == '1'
  puts `cf create-service cleardb spark mysql`
end

push_app(buildpack_url)

app_route_host = get_app_route_host(app_name)

request_uri = URI("https://#{app_route_host}.#{cf_domain}#{path_to_get}")

if app_name == 'railspong'
  response = Net::HTTP.start(request_uri.host, request_uri.port, :use_ssl => true) do |http|
    req = Net::HTTP::Delete.new(request_uri)
    http.request(req)
  end
else
  response = Net::HTTP.get_response("#{app_route_host}.#{cf_domain}",path_to_get)
end

delete_space(cf_app_space)

if response.code == "200"
  puts 'Got HTTP response 200. App push successful'
else
  puts "Got HTTP response #{response.code}. App push unsuccessful"
  exit 1
end
