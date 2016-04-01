module Jda
  class Filter
    def initialize(options = {})
      @name = options.fetch(:name) { fail ArgumentError, "missing name" }
      @index = options[:index].to_i
      @matchers = fetch_matchers(options[:matchers])
    end

    def match?(row)
      val = row[@index].strip
      @matchers.include?(val)
    end

    def empty?
      @matchers.empty?
    end

    private

    def fetch_matchers(matchers)
      return matchers.split(",").map!(&:strip) if matchers.respond_to?(:split)
      Array(matchers)
    end
  end
end
