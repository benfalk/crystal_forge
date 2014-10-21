require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = '--tags ~@wip'
end

task default: [:spec, :cucumber, :rubocop]
