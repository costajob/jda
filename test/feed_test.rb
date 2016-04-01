require "test_helper"
require "jda/feed"

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
end
