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
    let(:instance) { described_class.new(example_raml) }
    subject { instance }
    its(:resources) { is_expected.to be_kind_of(Enumerable) }
    its('resources.count') { is_expected.to eq(1) }

    context 'The only resource' do
      subject { instance.resources.first }
      its('actions.count') { is_expected.to eq(2) }
    end
  end

  describe CrystalForge::Formats::RAML::RawResource do
    let(:raw_node) { Raml::Parser.parse(example_raml).resources.first.resources.first }
    let(:instance) { described_class.new(raw_node) }

    describe '#actions' do
      subject { instance.actions.map(&:method) }
      it { is_expected.to be_kind_of(Enumerable) }
      it { is_expected.to include 'GET' }
      it { is_expected.to include 'DELETE' }
    end

    describe '#uri_template' do
      subject { instance.uri_template }
      it { is_expected.to eq '/messages/{id}' }
    end
  end
end
