#!/usr/bin/env rake
require "bundler/gem_tasks"

task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/test_*.rb') { |f| require f }
end

task :default => :test

desc "Open an pry session with Gasoline loaded"
task :console do
  require 'pry'
  require './lib/wasko'
  ARGV.clear
  Pry.start Wasko
end
