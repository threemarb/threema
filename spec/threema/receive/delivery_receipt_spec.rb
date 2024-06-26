# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::Receive::DeliveryReceipt do
  subject { described_class.new(**attributes) }
  let(:attributes) { attributes_for(:delivery_receipt_receive) }

  context '#content' do
    it 'returns the content' do
      expect(subject.content).to eq(attributes[:content])
    end
  end

  context '#message_ids' do
    let(:attributes) { { content: "\x01\xE0\xC8\x12n8]\xF3\x19J\xB4+ \xC9\xAB|\xB6\xAAc#\v|Ro(".b } }

    describe 'given a content string with three unhexified message ids' do
      it 'returns the hexified message ids' do
        expect(subject.message_ids).to eq(%w[e0c8126e385df319 4ab42b20c9ab7cb6 aa63230b7c526f28])
      end
    end
  end

  context '#timestamp' do
    it 'returns a timestamp' do
      expect(subject.timestamp).to be_an_instance_of(Integer)
      expect(Time.at(subject.timestamp, in: 'UTC')).to be_an_instance_of(Time)
    end
  end

  context '#status' do
    context 'received type' do
      it 'returns status received' do
        expect(subject.status).to eq(:received)
      end
    end

    context 'read type' do
      let(:attributes) { { content: "\x02\xE0\xC8\x12n8]\xF3\x19".b } }

      it 'returns status read' do
        expect(subject.status).to eq(:read)
      end
    end

    context 'the recipient explicitly reacts to the message by long pressing on it and' do
      context 'acknowledges it by tapping on the thumbs up' do
        let(:attributes) { { content: "\x03\xE0\xC8\x12n8]\xF3\x19".b } }

        it 'returns status explicitly_acknowledged' do
          expect(subject.status).to eq(:explicitly_acknowledged)
        end
      end

      context 'declines it by tapping on the thumbs down' do
        let(:attributes) { { content: "\x04\xE0\xC8\x12n8]\xF3\x19".b } }

        it 'returns status explicity_declined' do
          expect(subject.status).to eq(:explicity_declined)
        end
      end
    end
  end
end
