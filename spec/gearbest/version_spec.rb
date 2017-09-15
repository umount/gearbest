require 'spec_helper'

describe 'Gearbest Version' do
  it 'has a version number' do
    expect(Gearbest::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
