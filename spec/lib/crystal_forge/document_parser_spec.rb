require 'spec_helper'

describe CrystalForge::DocumentParser do
  let(:example_apib) { File.read(HELLO_WORLD_APIB) }

  it 'should initialize with an apib string' do
    expect { described_class.new(example_apib) }.to_not raise_error
  end

  describe '#resources' do
    subject { described_class.new(example_apib).resources }
    its(:count) { is_expected.to eq(1) }
    it { is_expected.to all be_a(CrystalForge::DocumentParser::Resource) }
  end
end
