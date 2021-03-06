require 'csv'

module Jda
  class Feed
    OPTIONS = { :quote_char => '"', :col_sep => ",", :row_sep => :auto, :encoding => "windows-1251:utf-8" }
    VALID_EXTENSIONS = %w[.txt]

    def self.ext_pattern
      "*{#{VALID_EXTENSIONS.join(",")}}"
    end

    def initialize(name)
      @name = name
    end

    def basename
      @basename ||= File.basename(@name)
    end

    def read
      CSV.foreach(@name, OPTIONS) do |row|
        yield(row)
      end
    end
  end
end
