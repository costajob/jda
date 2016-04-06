require 'csv'

module Jda
  class Report
    REPORTS_PATH = File::expand_path("../../../reports/", __FILE__)

    attr_reader :data

    def initialize(options = {})
      @name = options.fetch(:name) { fail ArgumentError, "missing name" }
      @data = options.fetch(:data) { fail ArgumentError, "missing data" }
      @dir = options.fetch(:dir) { REPORTS_PATH }
    end

    def header
      "#{@name} - #{@data.size} #{inflect("matching")}"
    end

    def write
      return if @data.empty?
      CSV.open(output, "w") do |report|
        @data.each do |row|
          report << row
        end
      end
    end

    private

    def inflect(str)
      return (str << "s") if @data.size != 1
      str
    end

    def output
      File::join(@dir, "#{@name}.csv")
    end
  end
end
