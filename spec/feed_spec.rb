require 'spec_helper'
require 'stubs'
require 'jda/feed'

describe Jda::Feed do
  let(:gz) { Jda::Feed::new("/jda/ebuscz-20160112083201.tgz") }
  let(:txt) { Jda::Feed::new("/jda/ebuscz-import.txt") }

  it "must get the basename" do
    gz.basename.must_equal "ebuscz-20160112083201"
    txt.basename.must_equal "ebuscz-import"
  end

  it "must fail for non TGZ file" do
    -> { txt.read() }.must_raise Jda::Feed::InvalidTGZError
  end

  it "must read CSV data" do
    stubs = Stubs::new
    feed = Jda::Feed::new(stubs.ebuseu)
    data = feed.read
    data.must_be_instance_of Array
    data.first[0].must_match /^806932926/
    data.first[1].must_match /^20102/
    data.first[14].must_equal "Y"
  end 
end
