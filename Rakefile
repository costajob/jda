require "bundler/gem_tasks"
require "rake/testtask"
import "lib/tasks/jda.rake"

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

task :default => :spec
