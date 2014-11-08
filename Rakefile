require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yardstick/rake/verify'
require 'yardstick/rake/measurement'
require 'yaml'

YARDSTICK_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/.yardstick.yml")

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = '--tags ~@wip'
end

Cucumber::Rake::Task.new('cucumber:wip') do |t|
  t.cucumber_opts = '--wip --tags @wip'
end

Yardstick::Rake::Verify.new(:verify_measurements, YARDSTICK_CONFIG) do |verify|
  verify.require_exact_threshold = false
end

Yardstick::Rake::Measurement.new(:yard_report, YARDSTICK_CONFIG) do |measurement|
  measurement.output = 'coverage/yard_report.txt'
end

task default: [:spec, :cucumber, 'cucumber:wip', :rubocop, :verify_measurements]
