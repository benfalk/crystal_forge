require 'spec_helper'

module CrystalForge
  describe WebServer::Route do
    let(:example_apib) { File.read(HELLO_WORLD_APIB) }
    let(:raw_resource) { DocumentParser.new(example_apib).send(:ast_resources).first }
    let(:http_method)  { 'GET' }
    let(:instance)     { described_class.new(raw_resource, http_method) }
    let(:env) do
      {
        'PATH_INFO' => '/messages/motd',
        'QUERY_STRING' => '',
        'REQUEST_METHOD' => 'GET',
        'REQUEST_URI' => 'http://localhost:8080/messages/motd',
        # 'rack.input'=>#<StringIO:0x007fcdc806bf88>,
        # 'rack.errors'=>#<IO:<STDERR>>,
        'rack.multithread' => true,
        'rack.multiprocess' => false,
        'rack.run_once' => false,
        'rack.url_scheme' => 'http',
        'HTTP_VERSION' => 'HTTP/1.1',
        'REQUEST_PATH' => '/messages/motd'
      }
    end
  end
end
