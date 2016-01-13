require "csv"
require "zlib"
require "rubygems/package"

module Jda
  Feed = Struct::new(:name) do
    TAR_GZ = %w[.tar.gz .tgz]

    def ext
      @ext ||= File.extname(self.name)
    end

    def basename
      @basename ||= File.basename(self.name, ext)
    end

    def data
      return File.read(self.name) unless tar_gz?
      data = nil
      File.open(self.name, "rb") do |file|
        Zlib::GzipReader.wrap(file) do |gz|
          Gem::Package::TarReader.new(gz) do |tar|
            data = tar.each.first.read
          end
        end
      end
      data
    end

    def tar_gz?
      TAR_GZ.include?(ext)
    end
  end

  class Parser
    ROOT = File.expand_path("../../..", __FILE__)
    OPTIONS = { quote_char: '"', col_sep: ",", row_sep: :auto, encoding: "windows-1251:utf-8" }

    attr_reader :feeds, :cache

    def initialize(files:)
      @feeds = files.map! { |name| Feed::new(name) }
      @cache = {}
      read_all
    end
    
    def filter!(skus: [], stores: [], md_flag: false)
      @cache.each do |feed, thread|
        thread.value.select! do |row|
          skus_cond = skus.empty? ? true : skus.include?(row[0].strip!)
          stores_cond = stores.empty? ? true : stores.include?(row[1].strip!)
          md_flag_cond = md_flag ? row[14] == "Y" : true
          skus_cond && stores_cond && md_flag_cond
        end
      end
    end

    def report
      @cache.each do |feed, thread|
        report_file = "#{ROOT}/reports/#{feed.basename}.csv"
        CSV.open(report_file, "w") do |report|
          thread.value.each do |row|
            report << row
          end
        end
      end
    end
    
    private

    def read_all
      @feeds.each do |feed|
        @cache[feed] = Thread::new { CSV.parse(feed.data, OPTIONS) }
      end
    end
  end
end
