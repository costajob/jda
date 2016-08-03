require 'spec_helper'
require 'jda/feed'

describe Jda::Feed do
  it 'must return feed directory patterns' do
    Jda::Feed.ext_pattern.must_equal "*{.txt}"
  end

  it 'must parse CSV data' do
    src = File.expand_path("../../samples/ebuskr.txt", __FILE__)
    feed = Jda::Feed.new(src)
    skus = []
    feed.read do |row|
      skus << row[0]
    end
    skus.size.must_equal 30
    skus[0].strip.must_equal "804017365"
  end

  it 'must return base name' do
    src = File.expand_path("../../samples/ebuskr.txt", __FILE__)
    feed = Jda::Feed.new(src)
    feed.basename.must_equal "ebuskr.txt"
  end
end
