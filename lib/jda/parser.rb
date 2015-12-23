require "csv"

module Jda
  class Parser

    OPTIONS = { quote_char: '"', col_sep: ",", row_sep: :auto, encoding: "windows-1251:utf-8" }

    attr_reader :files, :cache

    def initialize(files: [])
      @files = files
      @cache = {}
    end
    
    def read_all
      @files.each do |file|
        @cache[file] = Thread::new { CSV.read(file, OPTIONS) }
      end
    end

    def filter!(skus: [], stores: [], md_flag: false)
      @cache.each do |file, thread|
        thread.value.select! do |row|
          normalize_row!(row)
          skus_cond = skus.empty? ? true : skus.include?(row[0])
          stores_cond = stores.empty? ? true : stores.include?(row[1])
          md_flag_cond = md_flag ? md_flag == row[14] : true
          skus_cond && stores_cond && md_flag_cond
        end
      end
    end

    private

    def normalize_row!(row)
      [0, 1, 14].each do |i|
        row[i].strip!
      end
      row[14] = row[14] == 'Y' ? true : false
    end
  end
end
