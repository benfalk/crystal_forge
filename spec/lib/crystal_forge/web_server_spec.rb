require 'spec_helper'

describe CrystalForge::WebServer do
  let(:example_apib) { File.read(HELLO_WORLD_APIB) }

  context 'when initialized with a blueprint' do
    let(:instance) { described_class.new(example_apib) }

    describe '#start!' do
      it 'starts listening for web requests'
    end
  end
end
