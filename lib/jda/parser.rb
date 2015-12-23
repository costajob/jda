require "csv"

module Jda
  class Parser

    OPTIONS = { quote_char: '"', col_sep: ",", row_sep: :auto, encoding: "windows-1251:utf-8" }

    attr_reader :files, :cache

    def initialize(files:)
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
          skus_cond = skus.empty? ? true : skus.include?(row[0].strip!)
          stores_cond = stores.empty? ? true : stores.include?(row[1].strip!)
          md_flag_cond = md_flag ? row[14] == "Y" : true
          skus_cond && stores_cond && md_flag_cond
        end
      end
    end

    def report
      @cache.each do |file, thread|
        report_file = "../../reports/#{File.basename(file, ".txt")}_report.csv"
        Thread.new do
          CSV.open(report_file, "w") do |report|
            thread.value.each do |row|
              report << row
            end
          end
        end
      end
    end
  end
end
