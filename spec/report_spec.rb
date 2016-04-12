require 'spec_helper'
require 'jda/report'

describe Jda::Report do
  let(:dir) { Dir.mktmpdir("./reports") }
  let(:row) { %Q{804019219  ,20401  ,"Geneve Rhone                  ",1        ,0        ,0        ,100  ,"HANDBAGS                 ",1       ,"246907CTA4G    ",1000  ,"0099","1000/ /NEW JACKIE MD SOFT DEER",2150.00        ," ",0       ,0      ,1}.split(",") }
  let(:report) { Jda::Report::new(:dir => dir, :name => "ebuswh-20160111091250", :data => [row]) }
  let(:empty) { Jda::Report::new(:name => "ebuspf1-20160111141248", :data => []) }

  it "must return singular inflection" do
    report.header.must_equal "ebuswh-20160111091250 - 1 matching"
  end

  it "must return plural inflection" do
    empty.header.must_equal "ebuspf1-20160111141248 - 0 matchings"
  end

  it "must write to dir" do
    report.write 
    file = report.send(:output)
    assert File::exist?(file)
    File::read(file).must_match /^#{row}/
  end

  it "must prevent writing when data are empty" do
    empty.write 
    refute File::exist?(empty.send(:output))
  end
end
