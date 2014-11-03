require 'spec_helper'

describe CrystalForge::DocumentParser::AST do
  let!(:extended_class) { Class.new(described_class) }

  describe 'asts' do
    subject { described_class.asts }
    it { is_expected.to be_kind_of(Array) }
    it { is_expected.to include(extended_class) }
  end

  describe 'understands?' do
    it 'raises a NotImplemented error explaining how it should be used' do
      expect { described_class.understands? 'garblooly goop' }.to raise_error(NotImplementedError)
    end
  end

  describe 'parse' do
    let(:subclass_ast) { double(:parser, understands?: false, new: :foobar) }
    before do
      expect(described_class).to receive(:asts).and_return([subclass_ast])
    end

    it 'raises an exception when no subclassed parser understands it' do
      expect { described_class.parse('ahoy!') }
        .to raise_error(CrystalForge::DocumentParser::AST::UnkownFormat)
    end

    it 'uses the first subclassed ast that understands the format' do
      expect(subclass_ast).to receive(:understands?).and_return(true)
      expect(described_class.parse('ahoy!')).to eq(:foobar)
    end
  end
end
