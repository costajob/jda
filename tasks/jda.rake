require "benchmark"
require "./lib/jda/parser"

namespace :jda do
  desc "Create a report by reading JDA files into the specified folder (default to root=/jda), by filtering basing on skus, stores and MD flag"
  task :report do
    reports = []
    tms = Benchmark::measure do
      dir = ENV.fetch("dir", "/jda")
      skus = Jda::Filter::new(name: "skus", index: 0, matchers: ENV.fetch("skus", ""))
      stores = Jda::Filter::new(name: "strores", index: 1, matchers: ENV.fetch("stores", ""))
      md = Jda::Filter::new(name: "md", index: 14, matchers: ENV.fetch("md", ""))
      parser = Jda::Parser::new(dir: dir, filters: [skus, stores, md])
      reports = parser.report
      puts reports.map(&:header)
    end
    puts "Parsing completed in #{tms.real.round(9)}s"
    
    puts "Generate reports? [y/n]"
    answer = STDIN.gets.chomp
    if answer.match(/Y/i)
      reports.each(&:write) 
      puts "Check created reports at: \"./reports\""
    end
  end

  desc "Clean created reports"
  task :clean do
    Dir["#{File.expand_path("../../reports", __FILE__)}/*.csv"].each { |f| File.delete(f) }
  end
end
