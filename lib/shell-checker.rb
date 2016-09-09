require 'find'
require 'pathname'
require 'set'

class ShellChecker
  def check_shell_files(directory:)
    shell_files = find_shell_files(directory)
    shellcheck_results = {}
    shell_files.map do |shell_file_path|
      shellcheck_results[shell_file_path] = `shellcheck #{shell_file_path}`
    end

    shellcheck_results
  end

  private

  def find_shell_files(directory)
    paths_matched = Set.new

    Find.find(directory) do |file_path|
      if FileTest.file?(file_path)
        paths_matched << file_path if contains_shebang?(file_path)
        paths_matched << file_path if ends_with_sh?(file_path)
      end
    end

    paths_matched
  end

  def contains_shebang?(file_path)
    File.open(file_path) { |file| file.readline }.match /^#!.*bash/
  end

  def ends_with_sh?(file_path)
    Pathname.new(file_path).basename.to_s.end_with?('.sh')
  end
end
