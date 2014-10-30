require 'spec_helper'

module CrystalForge
  describe WebServer::Route do
    let(:example_apib) { File.read(HELLO_WORLD_APIB) }
    let(:raw_resource) { DocumentParser.new(example_apib).send(:ast_resources).first }
    let(:http_method)  { 'GET' }
    let(:path)         { '/messages/motd' }
    let(:instance)     { described_class.new(raw_resource, http_method) }
    let(:env) do
      {
        'PATH_INFO' => path,
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
        'REQUEST_PATH' => path
      }
    end

    describe '#matches?' do
      subject { instance.matches? env }
      it { is_expected.to be(true) }

      context 'when http_method is "DELETE"' do
        let(:http_method) { 'DELETE' }
        it { is_expected.to be(false) }
      end

      context 'when the path is "/junk/it"' do
        let(:path) { '/junk/it' }
        it { is_expected.to be(false) }
      end
    end

    describe '#rack_response' do
      subject { instance.rack_response }
      it { is_expected.to be_a(Array) }
      its(:size) { is_expected.to be(3) }

      describe 'the first element' do
        subject { instance.rack_response.first }
        it { is_expected.to eq('200') }
      end

      describe 'the second element' do
        subject { instance.rack_response[1] }
        it { is_expected.to be_a(Hash) }
        its(:keys) { is_expected.to include('Content-Type') }
      end
    end
  end
end
