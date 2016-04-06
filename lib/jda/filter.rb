module Jda
  class Filter
    attr_reader :index, :matchers

    def initialize(options = {})
      @name = options.fetch(:name) { fail ArgumentError, "missing name" }
      @index = options[:index].to_i
      @matchers = fetch_matchers(options[:matchers])
    end

    def match?(row)
      @matchers.include?(val(row))
    end

    def empty?
      @matchers.empty?
    end

    private

    def val(row)
      row[@index].strip! || row[@index]
    end

    def fetch_matchers(matchers)
      return matchers.split(",").map!(&:strip) if matchers.respond_to?(:split)
      Array(matchers)
    end
  end
end
