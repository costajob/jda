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

    def exec
      feeds.each do |feed|
        fork { yield(report(feed)) }
      end
      Process.waitall
    end

    def report(feed)
      data = feed.read()
      data.select! do |row|
        @filters.all? { |filter| filter.match?(row) } 
      end
      Report::new(name: feed.basename, data: data)
    end

    private

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
