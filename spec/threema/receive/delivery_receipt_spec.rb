# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::Receive::DeliveryReceipt do
  subject { described_class.new(**attributes) }
  let(:attributes) { attributes_for(:delivery_receipt_receive) }

  context '#content' do
    it { is_expected.to respond_to(:content) }

    it 'returns the content' do
      expect(subject.content).to eq(attributes[:content])
    end
  end

  context 'message ids' do
    let(:attributes) { { content: "\x01\xE0\xC8\x12n8]\xF3\x19J\xB4+ \xC9\xAB|\xB6\xAAc#\v|Ro(".b } }

    it 'returns an array of message ids' do
      expect(subject.message_ids).to be_a(Array)
    end

    it 'with each message id' do
      expect(subject.message_ids.length).to eq(3)
    end

    it 'with correct length' do
      expect(subject.message_ids.all? { |string| string.length.eql?(16) }).to be(true)
    end
  end

  context 'received type' do
    it 'returns received_at' do
      expect(Time.iso8601(subject.received_at)).to be_a_kind_of(Time)
    end
  end

  context 'read type' do
    let(:attributes) { { content: "\x02\xE0\xC8\x12n8]\xF3\x19".b } }

    it 'returns read_at' do
      expect(Time.iso8601(subject.read_at)).to be_a_kind_of(Time)
    end
  end

  context 'explicitly_acknowledged type' do
    let(:attributes) { { content: "\x03\xE0\xC8\x12n8]\xF3\x19".b } }

    it 'returns explicitly_acknowledged_at' do
      expect(Time.iso8601(subject.explicitly_acknowledged_at)).to be_a_kind_of(Time)
    end
  end

  context 'explicity_declined type' do
    let(:attributes) { { content: "\x04\xE0\xC8\x12n8]\xF3\x19".b } }

    it 'returns explicity_declined_at' do
      expect(Time.iso8601(subject.explicity_declined_at)).to be_a_kind_of(Time)
    end
  end
end
