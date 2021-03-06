# encoding: utf-8
require 'spec_helper'

describe 'commit-shas' do
  before :context do
    `git init ./spec/commit-shas`
    execute('-c tasks/commit-shas.yml -i buildpacks-ci=. -i buildpack-checksums=./spec/commit-shas -i buildpack-artifacts=./spec/commit-shas/pivotal-buildpacks-cached')
  end

  it 'has a helpful commit message' do
    output = run('cd /tmp/build/*/sha-artifacts && git log -- buildpack.zip.SHA256SUM.txt')
    expect(output).to include 'SHA256SUM for buildpack.zip'
  end
end
