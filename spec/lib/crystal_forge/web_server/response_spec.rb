require 'spec_helper'

describe CrystalForge::WebServer::Response do
  let(:example_apib) { File.read(HELLO_WORLD_APIB) }
  let(:instance)     { described_class.new(raw_response: raw_response) }
  let(:raw_response) do
    CrystalForge::DocumentParser::AST.parse(example_apib).resources
      .first
      .actions.first
      .examples.first
      .responses.first
  end

  subject { instance }

  its(:status_code) { is_expected.to eq('200') }
  its(:headers) { is_expected.to be_a(Hash) }

  context 'when the raw headers collection is nil' do
    before { allow(raw_response.headers).to receive(:collection).and_return(nil) }
    its(:headers) { is_expected.to eq({}) }
  end

  its(:body) { is_expected.to include('Hello World') }

  describe '#to_rack_response' do
    subject { instance.to_rack_response }
    it { is_expected.to be_an(Array) }
    its(:first) { is_expected.to eq('200') }
    it 'should be a hash for the second element' do
      expect(subject[1]).to eq('Content-Type' => 'text/plain')
    end
    it 'should contain an array with the body element in it' do
      allow(instance).to receive(:body).and_return(:body)
      expect(subject[2]).to eq([:body])
    end
  end
end
