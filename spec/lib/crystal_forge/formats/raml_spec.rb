require 'spec_helper'

describe CrystalForge::Formats::RAML do
  let(:example_raml) { File.read HELLO_WORLD_RAML }

  describe '#understands?' do
    it 'should be true for a valid document' do
      expect(described_class.understands? example_raml).to be(true)
    end

    it 'should be false for garbledee goop' do
      expect(described_class.understands? 'garbledee goop').to be(false)
    end
  end

  describe 'initalized with a valid document' do
    # TODO: raml-rb needs to support `example:`
    # subject { described_class.new(example_raml) }
    # its(:resources) { is_expected.to be_kind_of(Array) }
  end
end
