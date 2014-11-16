require 'spec_helper'

describe CrystalForge::WebServer do
  let(:example_apib) { File.read(HELLO_WORLD_APIB) }

  context 'when initialized with a blueprint' do
    let(:instance) { described_class.new(example_apib) }

    describe '#start!' do
      it 'starts listening for web requests' do
        expect(Rack::Handler::WEBrick).to receive(:run).with(instance, Port: 8080)
        instance.start!
      end

      it 'starts listening for web requests on specified port' do
        instance.port = 9021
        expect(Rack::Handler::WEBrick).to receive(:run).with(instance, Port: 9021)
        instance.start!
      end
    end

    describe '#call' do
      let(:matched_action) { double(:match, matches?: true, rack_response: valid_response) }
      let(:unmatched_action) { double(:unmatched, matches?: false) }
      let(:valid_response) { [200, { 'Content-Type' => 'text/plain' }, ['Hello World']] }
      let(:matching_actions) { [matched_action] }
      let(:unmatched_actions) { [unmatched_action] }

      context 'with a matching route' do
        before { allow(instance).to receive(:routes).and_return(matching_actions) }

        it 'should return a valid response' do
          expect(instance.call('foo')).to eq(valid_response)
        end
      end

      context 'with no matching route' do
        before { allow(instance).to receive(:routes).and_return(unmatched_actions) }

        it 'should be nil' do
          expect(instance).to receive(:nomatch_response).and_return(:foobar)
          expect(instance.call('foo')).to be(:foobar)
        end
      end
    end

    describe '#nomatch_response' do
      subject { instance.nomatch_response }
      it { is_expected.to eq(['404', {}, ['']]) }
    end
  end
end
