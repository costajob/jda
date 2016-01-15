require "test_helper"
require "jda/feed"

describe Jda::Feed do
  let(:gz) { Jda::Feed::new("/jda/ebuscz-20160112083201.tgz") }
  let(:txt) { Jda::Feed::new("/jda/ebuscz-import.txt") }

  it "must detect extension" do
    gz.ext.must_equal ".tgz"
    txt.ext.must_equal ".txt"
  end

  it "must detect tar gz files" do
    assert gz.tar_gz?
    refute txt.tar_gz?
  end

  it "must get the basename" do
    gz.basename.must_equal "ebuscz-20160112083201"
    txt.basename.must_equal "ebuscz-import"
  end
end
