require 'spec_helper'
require 'jda/report'

describe Jda::Report do
  it 'must render results' do
    report = Jda::Report.new("ebuskr.txt", Array.new(77))
    io = StringIO.new
    report.render(io)
    io.rewind
    io.read.must_equal "ebuskr.txt - matchings: 77\n"
  end
end
