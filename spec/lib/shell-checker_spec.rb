require 'spec_helper'
require_relative '../../lib/shell-checker'

describe ShellChecker do
  fixture_dir = File.join(__dir__, '../fixtures/shellchecker')

  describe 'finding scripts to check' do
    subject { ShellChecker.new.check_shell_files(directory: fixture_dir) }

    it 'finds files with a .sh extension' do
      expect(subject.keys).to include("#{fixture_dir}/no_shebang.sh", "#{fixture_dir}/shebang_with_extension.sh")
    end

    it 'finds files with a bash shebang line' do
      expect(subject.keys).to include("#{fixture_dir}/shebang_without_sh_extension", "#{fixture_dir}/shebang_with_extension.sh")
    end

    it 'only finds each file once' do
      expect(subject.keys).to contain_exactly("#{fixture_dir}/shebang_without_sh_extension", "#{fixture_dir}/shebang_with_extension.sh", "#{fixture_dir}/no_shebang.sh")
    end
  end
end
