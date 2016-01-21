require "jda/feed"
require "jda/filter"
require "jda/report"

module Jda
  class Parser
    class InvalidFeedPath < ArgumentError; end

    def initialize(dir:, filters:)
      fail InvalidFeedPath unless File.exists?(dir)
      @dir = dir
      @filters = remove_empty(filters)
    end

    def report
      feeds.map! do |feed|
        data = feed.read()
        data.select! do |row|
          @filters.all? { |filter| filter.match?(row) } 
        end
        Report::new(name: feed.basename, data: data)
      end
    end

    private

    def feeds
      @feeds ||= Dir["#{@dir}/*"]
        .select { |f| File.file?(f) }
        .map! { |name| Feed::new(name: name) }
    end

    def remove_empty(filters)
      Array(filters).reject { |filter| filter.empty? }
    end
  end
end
