require 'spec_helper'

describe CrystalForge::RoutingTable do
  let(:example_apib) { File.read(HELLO_WORLD_APIB) }

  context 'Initialized with Hello World apib' do
    let(:instance) { described_class.new(example_apib) }

    describe '#pretty_format' do
      subject { instance.pretty_format }

      it { is_expected.to include('GET /messages/{id}') }
      it { is_expected.to include('DELETE /messages/{id}') }
    end
  end
end
