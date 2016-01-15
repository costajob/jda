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
end
