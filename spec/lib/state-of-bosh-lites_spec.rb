# encoding: utf-8
require 'spec_helper'
require_relative '../../lib/state-of-bosh-lites'

describe StateOfBoshLites do
  before(:all) do
    allow(GitClient).to receive(:checkout_branch)
    allow(GitClient).to receive(:pull_current_branch)
    allow(GitClient).to receive(:get_current_branch)
    allow(GitClient).to receive(:)
  end


  describe '#get_states!' do

  end

  describe '#display_state' do

  end

  describe '#get_environment_status' do
    
  end
end
