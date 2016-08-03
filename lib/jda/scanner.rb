require 'jda/feed'
require 'jda/filter'
require 'jda/report'

module Jda
  class Scanner
    DEFAULT_PATH = File.expand_path("../../../samples", __FILE__)

    attr_reader :results

    def initialize(filters, dir = DEFAULT_PATH, out = StringIO.new)
      @filters = filters
      @dir = dir
      @out = out
      @results = Hash.new { |h,k| h[k] = [] }
    end

    def call
      feeds.each do |feed|
        compute(feed)
      end
    end

    def parallel_call
      feeds.each do |feed|
        fork { compute(feed) }
      end
      Process::waitall
    end

    private

    def compute(feed)
      feed.read do |row|
        @results[feed.basename] << row if @filters.all? { |filter| filter.match?(row) }
      end
      Report.new(feed.basename, @results[feed.basename]).render(@out)
    end

    def feeds
      @feeds ||= Dir["#{@dir}/#{Feed.ext_pattern}"].map! { |name| Feed::new(name) }
    end
  end
end
