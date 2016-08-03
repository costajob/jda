require 'spec_helper'
require 'jda/scanner'

describe Jda::Scanner do
  it 'must collect results with empty filters' do
    scanner = Jda::Scanner.new([])
    scanner.call
    scanner.results["ebuskr.txt"].size.must_equal 30
    scanner.results["ebuspf1.txt"].size.must_equal 24
  end

  it 'must collect results by sku filter' do
    filters = [Jda::Filters::Sku.new(%w(804511615 806732962 800907730))]
    scanner = Jda::Scanner.new(filters)
    scanner.call
    scanner.results["ebuskr.txt"].size.must_equal 3
    scanner.results["ebuspf1.txt"].size.must_equal 2
  end

  it 'must collect results by store filter' do
    filters = [Jda::Filters::Store.new(%w(25008 25005 23017))]
    scanner = Jda::Scanner.new(filters)
    scanner.call
    scanner.results["ebuskr.txt"].size.must_equal 7
    scanner.results["ebuspf1.txt"].size.must_equal 3
  end

  it 'must collect results by sale filter' do
    filters = [Jda::Filters::Sale.new]
    scanner = Jda::Scanner.new(filters)
    scanner.call
    scanner.results["ebuskr.txt"].size.must_equal 2
    scanner.results["ebuspf1.txt"].size.must_equal 1
  end


  it 'must collect results by combining filters' do
    filters = []
    filters << Jda::Filters::Sku.new(%w(804511615 806732962 800907730))
    filters << Jda::Filters::Store.new(%w(25008 25005 23017))
    filters << Jda::Filters::Sale.new
    scanner = Jda::Scanner.new(filters)
    scanner.call
    scanner.results["ebuskr.txt"].size.must_equal 1
    scanner.results["ebuspf1.txt"].size.must_equal 1
  end
end
