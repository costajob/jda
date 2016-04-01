require "jda/feed"
require "jda/filter"
require "jda/report"

module Jda
  class Parser
    class InvalidFeedPath < ArgumentError; end

    def initialize(options = {})
      @dir = options.fetch(:dir) { fail ArgumentError, "missing feeds directory" } 
      @filters = remove_empty(options[:filters])
      @persist = options.fetch(:persist) { false }
      check_dir
    end

    def exec
      feeds.each do |feed|
        report(feed)
      end
      Process.waitall
    end

    private

    def check_dir
      fail InvalidFeedPath unless File.exists?(@dir)
    end

    def report(feed)
      fork do
        data = feed.read()
        data.select! do |row|
          @filters.all? { |filter| filter.match?(row) } 
        end
        report = Report::new(name: feed.basename, data: data)
        puts report.header
        report.write if @persist
      end
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
