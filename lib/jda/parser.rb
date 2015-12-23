require "csv"

module Jda
  class Parser

    OPTIONS = { quote_char: '"', col_sep: ",", row_sep: :auto, encoding: "windows-1251:utf-8" }

    attr_reader :files

    def initialize(files: [])
      @files = files
      @cache = {}
    end
    
    def read_all
      @files.each do |file|
        @cache[file] = Thread::new { CSV.read(file, OPTIONS) }
      end
    end

    def filter!(skus: [], stores: [], md: false)
      @cache.each do |file, thread|
        thread.value.map! do |row|
          data
        end 
      end
    end
  end
end
