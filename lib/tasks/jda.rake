require './lib/jda'

namespace :jda do
  desc "Scan JDA files into the specified folder (default to /jda), by filtering data basing on skus, stores and MD flag, store report if specified"
  task :scanner do
    filters = []
    filters << Jda::Filters::new(ENV["skus"].to_a.split(",").map!(&:strip)) if ENV["skus"]
    filters << Jda::Filters::Store.new(ENV["stores"].to_a.split(",").map!(&:strip)) if ENV["stores"]
    filters << Jda::Filters::Sale.new if ENV["md"]
    dir = ENV.fetch("dir", "/jda")
    next if filters.empty?
    Jda::Scanner::new(filters, dir, STDOUT).parallel_call
  end
end
