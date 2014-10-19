require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new

task default: [:spec, :cucumber, :rubocop]
