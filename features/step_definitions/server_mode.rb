require 'open3'
require 'fileutils'
require 'faraday'

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

When(/^I get "(.*?)" from host "(.*?)"$/) do |uri, host|
  @response = Faraday.new(url: host).get(uri)
end

Then(/^the http body should include "(.*?)"$/) do |body_content|
  expect(@response.body).to include(body_content)
end

Then(/^the http status code should be "(.*?)"$/) do |expected_code|
  expect(@response.status).to eq(Integer(expected_code))
end

Then(/^the content\-type should be "(.*?)"$/) do |content_type|
  expect(@response.env.response_headers['content-type']).to eq(content_type)
end
