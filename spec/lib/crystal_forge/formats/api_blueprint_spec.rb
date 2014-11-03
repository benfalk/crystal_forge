require 'spec_helper'

describe CrystalForge::Formats::APIBlueprint do
  let(:api_blueprint) { File.read HELLO_WORLD_APIB }

  describe '#understands?' do
    it 'should be true for a valid file' do
      expect(described_class.understands? api_blueprint).to be(true)
    end

    it 'should return false for garble' do
      expect(described_class.understands? 'garble').to be(false)
    end
  end

  describe 'when initialized with a document' do
    subject { described_class.new(api_blueprint) }
    its(:resource_groups) { is_expected.to_not be_empty }
    its(:resources) { is_expected.to be_kind_of(Array) }
    its(:resources) { is_expected.to_not be_empty }
  end
end
