require "benchmark"
require "./lib/jda/parser"

namespace :jda do
  desc "Create a report by reading JDA files into the specified folder (default to /jda), by filtering basing on skus, stores and MD flag"
  task :report do
    reports = []
    tms = Benchmark::measure do
      dir = ENV.fetch("dir", "/jda")
      persist = ENV.fetch("persist") { false }
      skus = Jda::Filter::new(name: "skus", index: 0, matchers: ENV.fetch("skus", ""))
      stores = Jda::Filter::new(name: "strores", index: 1, matchers: ENV.fetch("stores", ""))
      md = Jda::Filter::new(name: "md", index: 14, matchers: ENV.fetch("md", ""))
      parser = Jda::Parser::new(dir: dir, filters: [skus, stores, md], persist: persist)
      parser.exec
    end
    puts "Parsing completed in #{tms.real.round(9)}s"
  end

  desc "Clean created reports"
  task :clean do
    Dir["#{File.expand_path("../../reports", __FILE__)}/*.csv"].each { |f| File.delete(f) }
  end
end
