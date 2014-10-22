require 'spec_helper'

describe CrystalForge::DocumentParser do
  let(:example_apib) { File.read(HELLO_WORLD_APIB) }

  it 'should initialize with an apib string' do
    expect { described_class.new(example_apib) }.to_not raise_error
  end
end
