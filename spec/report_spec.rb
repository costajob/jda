require "spec_helper"
require "jda/report"

describe Jda::Report do
  let(:row) { %Q{804019219  ,20401  ,"Geneve Rhone                  ",1        ,0        ,0        ,100  ,"HANDBAGS                 ",1       ,"246907CTA4G    ",1000  ,"0099","1000/ /NEW JACKIE MD SOFT DEER",2150.00        ," ",0       ,0      ,1}.split(",") }
  let(:single) { Jda::Report::new(name: "ebuswh-20160111091250", data: [row]) }
  let(:empty) { Jda::Report::new(name: "ebuspf1-20160111141248", data: []) }

  it "must return singular inflection" do
    single.header().must_equal "ebuswh-20160111091250 - 1 matching"
  end

  it "must return plural inflection" do
    empty.header().must_equal "ebuspf1-20160111141248 - 0 matchings"
  end
end
