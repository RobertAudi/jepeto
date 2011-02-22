require "rake/testtask"
require 'bundler'
Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/test_*.rb"]
end

task :default => :test
