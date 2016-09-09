#!/usr/bin/env ruby

require_relative '../../lib/shell-checker'

directory_to_inspect = ENV['DIRECTORY_TO_CHECK']

puts "Checking #{directory_to_inspect}"

shell_checker = ShellChecker.new.check_shell_files(directory: directory_to_inspect)

puts "Found #{shell_checker.size} shell files to inspect"

shell_checker.each do |file_path, shellcheck_output|
  puts '########################################################################################'
  puts "## shellcheck results for #{file_path}"
  puts '########################################################################################'
  puts shellcheck_output
end
