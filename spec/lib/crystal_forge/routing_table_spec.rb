require 'spec_helper'

HELLO_WORLD_APIB = "#{File.dirname(__FILE__)}/../../../apib_files/hello_world.apib"

describe CrystalForge::RoutingTable do
  let(:example_apib) { File.read(HELLO_WORLD_APIB) }

  it 'should initialize with an apib string' do
    expect { described_class.new(example_apib) }.to_not raise_error
  end

  context 'Initialized with Hello World apib' do
    let(:instance) { described_class.new(example_apib) }

    describe '#pretty_format' do
      subject { instance.pretty_format }

      it { is_expected.to include('GET /messages/{id}') }
      it { is_expected.to include('DELETE /messages/{id}') }
    end
  end
end
