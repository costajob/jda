require "csv"
require "zlib"
require "rubygems/package"

module Jda
  class Feed
    TGZ = %w[.tar.gz .tgz]
    OPTIONS = { quote_char: '"', col_sep: ",", row_sep: :auto, encoding: "windows-1251:utf-8" }

    class InvalidTGZError < ArgumentError; end

    def initialize(name:)
      @name = name
    end

    def basename
      @basename ||= File.basename(@name, ext)
    end

    def read
      fail InvalidTGZError unless tgz?
      data = []
      File.open(@name, "rb") do |file|
        Zlib::GzipReader.wrap(file) do |gz|
          Gem::Package::TarReader.new(gz) do |tar|
            csv = tar.each.first.read
            data = CSV.parse(csv, OPTIONS)
          end
        end
      end
      data
    end

    private

    def tgz?
      TGZ.include?(ext)
    end

    def ext
      @ext ||= File.extname(@name)
    end
  end
end
