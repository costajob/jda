require 'spec_helper'
require 'stubs'
require 'jda/scanner'

describe Jda::Scanner do
  it "must raise an error for infalid JDA path" do
    -> { Jda::Scanner::new(dir: "noent", filters: nil) }.must_raise Jda::Scanner::InvalidFeedPath
  end

  describe "#exec" do
    let(:stubs) { Stubs::new }
    let(:skus) { Jda::Filter::new(name: "skus", index: 0, matchers: %w[806932926 807014019 800968215]) }
    let(:md) { Jda::Filter::new(name: "md", index: 14, matchers: %w[Y]) }

    it "must return a filtered report" do
      feed = Jda::Feed::new(stubs.ebuseu)
      scanner = Jda::Scanner::new(dir: stubs.dir, filters: [skus])
      report = scanner.report(feed)      
      report.must_be_instance_of Jda::Report
    end
  end
end
