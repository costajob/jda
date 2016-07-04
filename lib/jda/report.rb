require 'csv'

module Jda
  class Report
    def initialize(name, data)
      @name = name
      @data = Array(data)
    end

    def render(io)
      io.puts header
    end

    private 
    
    def header
      "#{@name} - matchings: #{@data.size}"
    end
  end
end
