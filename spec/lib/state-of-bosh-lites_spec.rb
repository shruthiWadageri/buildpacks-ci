# encoding: utf-8
require 'spec_helper'
require_relative '../../lib/state-of-bosh-lites'

describe StateOfBoshLites do
  before(:all) do
    allow(GitClient).to receive(:checkout_branch)
    allow(GitClient).to receive(:pull_current_branch)
    allow(GitClient).to receive(:get_current_branch)
  end


  subject { described_class.new }

  describe '#get_states!' do
    allow(GitClient).to receive(:get_current_branch).and_return('develop')
    allow(subject).to receive(:get_environment_status).and_return( {'claimed' => true, 'job' => 'php-buildpack/specs-develop build 13'} )

    it 'switches to the resource-pools branch and back' do
      expect(GitClient).to receive(:checkout_branch).with('resource-pools')
      expect(GitClient).to receive(:checkout_branch).with('develop')
    end

    it 'gets the status of all the environments' do
    end

  end

  describe '#display_state' do

  end

  describe '#get_environment_status' do
    
  end
end
