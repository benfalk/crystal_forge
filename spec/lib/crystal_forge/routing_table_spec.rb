require 'spec_helper'

module CrystalForge
  describe CrystalForge::RoutingTable do
    let(:example_apib) { File.read(HELLO_WORLD_APIB) }

    context 'Initialized with Hello World apib' do
      let(:instance) { described_class.new(example_apib) }

      describe '#pretty_format' do
        subject { instance.pretty_format }
        it { is_expected.to include('GET /messages/{id}') }
        it { is_expected.to include('DELETE /messages/{id}') }
      end

      describe '#routes' do
        subject { instance.routes }
        its(:count) { is_expected.to eq(2) }
        it { is_expected.to all be_a(DocumentParser::SimpleRoute) }
      end
    end
  end
end
