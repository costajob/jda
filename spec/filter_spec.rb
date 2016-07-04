require 'spec_helper'
require 'jda/filter'

describe Jda::Filters::Base do
  let(:row) { %Q{804019219  ,20401  ,Geneve Rhone                  ,1        ,0        ,0        ,100  ,HANDBAGS                 ,1       ,246907CTA4G    ,1000  ,0099,1000/ /NEW JACKIE MD SOFT DEER,2150.00        ,Y, 999.00       ,0      ,1}.split(",") }

  it "must match by SKU" do
    filter = Jda::Filters::Sku.new(%w[804019219 805050823 805301038])
    assert filter.match?(row)
  end

  it "must match by store" do
    filter = Jda::Filters::Store.new(%w[20401 20402 20505])
    assert filter.match?(row) 
  end

  it "must match by sale price" do
    filter = Jda::Filters::Sale.new
    assert filter.match?(row) 
  end
end
