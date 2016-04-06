require 'jda/feed'
require 'jda/filter'
require 'jda/report'

module Jda
  class Scanner
    class InvalidFeedPath < ArgumentError; end

    def initialize(options = {})
      @dir = options.fetch(:dir) { fail ArgumentError, "missing feeds directory" } 
      @filters = remove_empty(options[:filters])
      @persist = options.fetch(:persist) { false }
      check_dir
    end

    def call(out = STDOUT)
      feeds.reduce([]) do |acc, feed|
        acc << compute(feed, out)
      end
    end

    def call_in_parallel(out = STDOUT)
      feeds.each do |feed|
        fork { compute(feed, out) }
      end
      Process::waitall
    end

    private

    def compute(feed, out)
      r = report(feed)
      out.puts r.header
      r.write if @persist
      r
    end

    def report(feed)
      data = feed.read
      data.select! { |row| filters_match?(row) }
      Report::new(name: feed.basename, data: data)
    end

    def filters_match?(row)
      @filters.all? { |filter| filter.match?(row) }
    end

    def check_dir
      fail InvalidFeedPath unless File.exists?(@dir)
    end

    def feeds
      @feeds ||= Dir["#{@dir}/*"]
        .select { |f| File.file?(f) }
        .map! { |name| Feed::new(name) }
    end

    def remove_empty(filters)
      Array(filters).reject { |filter| filter.empty? }
    end
  end
end
