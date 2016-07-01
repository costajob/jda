require 'spec_helper'
require 'stubs'
require 'jda/feed'

describe Jda::Feed do
  it "must get the basename" do
    feed = Jda::Feed::new("/jda/ebuscz-20160112083201.txt")
    feed.basename.must_equal "ebuscz-20160112083201.txt"
  end

  it "must read CSV data" do
    stubs = Stubs::Feeds::new
    feed = Jda::Feed::new(stubs.ebuseu)
    data = feed.read
    data.must_be_instance_of Array
    data.first[0].must_match /^806932926/
    data.first[1].must_match /^20102/
    data.first[14].must_equal "Y"
  end 
end
