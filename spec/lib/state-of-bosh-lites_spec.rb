# encoding: utf-8
require 'yaml'
require 'json'
require 'spec_helper'
require_relative '../../lib/state-of-bosh-lites'


describe StateOfBoshLites do
  let(:environments) {%w(edge-1.buildpacks.ci edge-2.buildpacks.ci lts-1.buildpacks.ci lts-2.buildpacks.ci)}

  before(:each) do
    allow(GitClient).to receive(:checkout_branch)
    allow(GitClient).to receive(:pull_current_branch)
    allow(GitClient).to receive(:get_current_branch)
  end


  subject { described_class.new }

  describe '#get_states!' do
    before(:each) do
      allow(GitClient).to receive(:get_current_branch).and_return('develop')
      allow(subject).to receive(:get_environment_status).and_return( {'claimed' => true, 'job' => 'php-buildpack/specs-develop build 13'} )
    end

    it 'switches to the resource-pools branch and back' do
      subject.get_states!

      expect(GitClient).to have_received(:checkout_branch).with('resource-pools')
      expect(GitClient).to have_received(:checkout_branch).with('develop')
    end

    it 'gets the status of all the environments' do
      subject.get_states!

      environments.each do |env|
        expect(subject).to have_received(:get_environment_status).with(env)
      end
    end
  end

  describe '#get_environment_status' do
    
  end
end
