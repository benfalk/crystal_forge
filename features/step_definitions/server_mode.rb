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
    err_lines = []
    Timeout.timeout(8) do
      loop do
        line = @stderr.gets
        break if line =~ /start/
        err_lines << line unless line.nil? || line.empty?
        fail "#{server_command} has failed!\n #{err_lines.join("\n")}" unless @wait_thr.alive?
      end
    end
  end
end

When(/^I (GET|DELETE) "(.*?)" from host "(.*?)"$/) do |method, uri, host|
  method = method.downcase.to_sym
  @response = Faraday.new(url: host).send(method, uri)
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

Then(/^the http body should be blank$/) do
  expect(@response.body).to eq('')
end

Then(/^the content\-type should be absent$/) do
  expect(@response.env.response_headers['content-type']).to be_nil
end
