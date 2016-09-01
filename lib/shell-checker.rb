require 'find'
require 'pathname'

class ShellChecker

  def find_shell_files(directory:)
    paths_matched = []

    Find.find(directory) do |file_path|
      file_basename = Pathname.new(file_path).basename.to_s

      paths_matched << file_path if file_basename.end_with?('.sh')

      if FileTest.file?(file_path)
        first_line = File.open(file_path) { |file| file.readline }
        paths_matched << file_path if first_line.match /^#!.*bash/
      end
    end

    paths_matched.uniq
  end
end
