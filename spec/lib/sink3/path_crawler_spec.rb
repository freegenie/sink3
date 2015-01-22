require 'spec_helper'

describe Sink3::PathCrawler do 
  let(:test_path) {
    File.expand_path('../../support/test_path')
  }
  it 'should find real file name' do 
    Sink3::PathCrawler.new(test_path)
  end

  it 'should crawl directories' do
  end

  it 'should set the correct remote_path' do
  end
end
