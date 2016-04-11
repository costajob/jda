require 'spec_helper'
require 'stubs'
require 'jda/scanner'

describe Jda::Scanner do
  it "must raise an error for infalid JDA path" do
    -> { Jda::Scanner::new(dir: "noent", filters: nil) }.must_raise Jda::Scanner::InvalidFeedPath
  end

  let(:stubs) { Stubs::Feeds::new }
  let(:skus) { Jda::Filter::new(name: "skus", index: 0, matchers: %w[806932926 807014019 800968215]) }
  let(:md) { Jda::Filter::new(name: "md", index: 14, matchers: %w[Y]) }
  let(:scanner) { Jda::Scanner::new(dir: stubs.dir, filters: [skus, md]) }

  it "must return a filtered report for each feed" do
    Stubs::Feeds::FILES.each { |name| Jda::Feed::new(stubs.send(name)) }
    reports = scanner.call(Stubs::TEST_IO)
    reports.each do |report|
      report.must_be_instance_of Jda::Report
      assert report.data.all? { |row| skus.matchers.include?(row[skus.index].strip) }
      assert report.data.all? { |row| md.matchers.include?(row[md.index]) }
    end
  end

  it "must call write if persist option is set" do
    Jda::Feed::new(stubs.ebuseu)
    scanner = Jda::Scanner::new(dir: stubs.dir, persist: true, filters: [md])
    any_instance_of(Jda::Report) do |klass|
      mock(klass).write
    end
    scanner.call(Stubs::TEST_IO)
  end
end
