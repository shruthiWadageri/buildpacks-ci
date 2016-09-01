require 'find'
require 'pathname'
require 'set'

class ShellChecker
  def find_shell_files(directory:)
    paths_matched = Hash.new

    Find.find(directory) do |file_path|
      if FileTest.file?(file_path)
        paths_matched[file_path] = "exists!!!1!" if contains_shebang?(file_path)
        paths_matched[file_path] = "exists!!!1!" if ends_with_sh?(file_path)
      end
    end

    paths_matched
  end

  private

  def contains_shebang?(file_path)
    File.open(file_path) { |file| file.readline }.match /^#!.*bash/
  end

  def ends_with_sh?(file_path)
    Pathname.new(file_path).basename.to_s.end_with?('.sh')
  end
end
