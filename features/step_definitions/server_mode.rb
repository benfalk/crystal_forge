require 'open3'
require 'fileutils'

After do
  Process.kill('KILL', @wait_thr[:pid]) if @wait_thr && @wait_thr.alive?
end

Given(/^I start `(.+)`$/) do |server_command|
  @root = Pathname.new(File.dirname(__FILE__)).parent.parent.expand_path
  FileUtils.mkdir_p "#{@root}/tmp/aruba"
  Dir.chdir "#{@root}/tmp/aruba" do
    command = "#{@root.join('bin')}/#{server_command}"
    @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(command)
    sleep 1 # so the daemon has a chance to boot
  end
  unless @wait_thr.alive?
    warn "STDERR: #{@stderr.read}"
    warn "STDOUT: #{@stdout.read}"
    fail "#{server_command} has failed!"
  end
end

When(/^I visit "(.*?)"$/) do |website_url|
  visit website_url
end
