require 'spec_helper'

describe CrystalForge::Formats::RAML do
  let(:example_raml) { File.read HELLO_WORLD_RAML }
  let(:raw_node)     { Raml::Parser.parse(example_raml).resources.first.resources.first }
  let(:raw_action)   { raw_node.methods.first }
  let(:raw_response) { raw_action.responses.first }
  let(:raw_body)     { raw_response.bodies.first }

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

  describe CrystalForge::Formats::RAML::RawAction do
    let(:instance) { described_class.new(raw_action) }
    subject { instance }

    its(:examples) { is_expected.to be_kind_of Enumerable }
    its('examples.count') { is_expected.to eq 1 }
    its(:method) { is_expected.to eq 'GET' }
  end

  describe CrystalForge::Formats::RAML::RawExample do
    let(:instance) { described_class.new(raw_response) }
    subject { instance }

    its(:responses) { is_expected.to be_kind_of Enumerable }
  end

  describe CrystalForge::Formats::RAML::RawResponse do
    let(:instance) { described_class.new(raw_body, raw_response) }
    subject { instance }

    its(:name) { is_expected.to eq '200' }
    its(:body) { is_expected.to include 'Hello World!' }
    its('headers.collection') { is_expected.to be_kind_of Enumerable }

    context 'with a blank raw_body' do
      let(:raw_body) { CrystalForge::Formats::RAML::RawExample::NullBody }
      its(:name) { is_expected.to eq '200' }
      its('headers.collection') { is_expected.to eq([]) }
      its(:body) { is_expected.to eq '' }
    end
  end
end
