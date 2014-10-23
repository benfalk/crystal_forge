require 'spec_helper'

module CrystalForge
  describe DocumentParser::Resource do
    let(:logical_actions) do
      [
        double(:put,  method: 'PUT'),
        double(:get,  method: 'GET'),
        double(:delete,  method: 'DELETE')
      ]
    end
    let(:raw_resource) do
      double :raw, uri_template: '/widgets/{id}',
                   actions: logical_actions
    end

    context 'initialized with a raw resource' do
      let(:instance) { described_class.new(raw_resource) }

      describe '#routes' do
        subject { instance.routes }

        its(:count) { is_expected.to be(3) }
        it { is_expected.to all be_a(DocumentParser::SimpleRoute) }
      end
    end
  end
end
