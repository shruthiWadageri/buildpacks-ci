# encoding: utf-8

require 'tmpdir'
require 'fileutils'
require_relative '../../../tasks/detect-and-upload/buildpack-tagger'

describe BuildpackTagger do
  let(:task_dir) { Dir.mktmpdir }
  let(:version)  { '99.99.99' }
  let(:timestamp) {'12345'}

  before(:each) do
    Dir.chdir(task_dir) do
      FileUtils.mkdir_p('buildpack')
      File.write('buildpack/VERSION',version)

      FileUtils.mkdir_p('pivotal-buildpack')
      File.write("pivotal-buildpack/testlang_buildpack-v#{version}+#{timestamp}.zip",'specfile')

      FileUtils.mkdir_p('pivotal-buildpack-cached')
      File.write("pivotal-buildpack-cached/testlang_buildpack-cached-v#{version}+#{timestamp}.zip",'specfile')

      FileUtils.mkdir_p('buildpack-artifacts')
    end
  end

  after(:each) do
    FileUtils.rm_rf(task_dir)
  end

  subject { described_class.new(File.join(task_dir, 'buildpack')) }

  context 'the tag already exists' do
    let(:git_tags) {"v1.1.1\nv2.2.2\nv99.99.99\n"}

    before do
      allow(described_class).to receive(:`).with('git tag').and_return(git_tags)
    end

    it 'copies the existing buildpacks to the artifacts directory' do
      subject.run!

      Dir.chdir(File.join(task_dir, 'buildpack-artifacts')) do
        output_buildpacks = Dir["*.zip"]
        expect(output_buildpacks).to include('testlang_buildpack-v99.99.99+12345.zip')
        expect(output_buildpacks).to include('testlang_buildpack-cached-v99.99.99+12345.zip')
      end
    end
  end
end
