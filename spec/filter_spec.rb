require 'spec_helper'
require 'jda/filter'

describe Jda::Filter do
  let(:skus) { Jda::Filter::new(name: "skus", index: 0, matchers: %w[804019219 805050823 805301038]) }
  let(:dept) { Jda::Filter::new(name: "dept", index: 6, matchers: %w[610 300]) }
  let(:empty) { Jda::Filter::new(name: "empty", index: nil, matchers: nil) }
  let(:row) { %Q{804019219  ,20401  ,"Geneve Rhone                  ",1        ,0        ,0        ,100  ,"HANDBAGS                 ",1       ,"246907CTA4G    ",1000  ,"0099","1000/ /NEW JACKIE MD SOFT DEER",2150.00        ," ",0       ,0      ,1}.split(",") }

  it "must match existing values" do
    assert skus.match?(row)
  end

  it "wont match missing values" do
    refute dept.match?(row)
  end

  it "must detect empty filter" do
    assert empty.empty?
  end

  it "must create matchers from CSV string" do
    filter = Jda::Filter::new(name: "stores", index: 1, matchers: "20401, 20402,20505")
    assert filter.match?(row) 
  end
end
