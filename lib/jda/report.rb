require "csv"

module Jda
  class Report
    def initialize(name:, data:)
      @name = name
      @data = data
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
      File.expand_path("../../../reports/#{@name}.csv", __FILE__)
    end
  end
end
