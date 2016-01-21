module Jda
  class Filter
    def initialize(name:, index:, matchers:)
      @name = name
      @index = index.to_i
      @matchers = fetch_matchers(matchers)
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
