# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe Threema::Receive do
  let(:test_date) { Time.now.to_i }
  let(:public_key) { test_public_key }

  it 'responds to e2e' do
    expect(described_class).to respond_to(:e2e)
  end

  describe '.e2e' do
    subject { -> { described_class.e2e(payload: payload, threema: build(:threema), public_key: public_key) } }
    let(:initial_payload) { build(:text_message, public_key: test_public_key).payload }
    let(:payload) do
      the_payload = initial_payload
      the_payload[:from]      = test_from
      the_payload[:messageId] = test_message_id
      the_payload[:date]      = test_date
      the_payload[:mac] = Threema::E2e::MAC.generate(
        payload: the_payload,
        api_secret: test_api_secret,
      )
      the_payload
    end

    describe 'requires the following payload parameters:' do
      it 'box' do
        payload.delete(:box)
        should raise_error(ArgumentError)
      end

      it 'nonce' do
        payload.delete(:nonce)
        should raise_error(ArgumentError)
      end

      it 'from' do
        payload.delete(:from)
        should raise_error(ArgumentError)
      end

      it 'messageId' do
        payload.delete(:messageId)
        should raise_error(ArgumentError)
      end

      it 'mac parameter' do
        payload.delete(:mac)
        should raise_error(ArgumentError)
      end

      context 'if all required parameters are given (sanity check)' do
        it { should_not raise_error }
      end
    end

    describe 'errors' do
      describe 'in case mac parameter validation fails' do
        before { payload[:mac] = 'compromised' }
        it { should raise_error(RuntimeError) }
      end

      describe 'in case no public key for sender could be found' do
        let(:public_key) { nil }
        before { mock_error(404) }
        it { should raise_error(RuntimeError) }
      end
    end

    context 'for text messages' do
      let(:payload) do
        attributes = attributes_for(:text_message)

        mock_pubkey(attributes[:threema_id], test_public_key)

        instance = Threema::Send::Text.new(attributes)

        payload = instance.payload

        # required params
        payload[:from]      = test_from
        payload[:messageId] = test_message_id
        payload[:date]      = test_date

        mac = Threema::E2e::MAC.generate(
          payload: payload,
          api_secret: test_api_secret,
        )

        payload[:mac] = mac
        payload
      end

      it 'creates instance of Threema::Receive::Text' do
        expect(subject.call).to be_a(Threema::Receive::Text)
      end
    end

    context 'for delivery receipts' do
      let(:initial_payload) do
        attributes = attributes_for(:text_message).merge(public_key: test_public_key)
        Threema::Send::E2EBase.new(attributes).send(:generate_payload, :delivery_receipt, 'whatever')
      end

      it 'creates instance of type Threema::Receive::DeliveryReceipt' do
        expect(subject.call).to be_a(Threema::Receive::DeliveryReceipt)
      end
    end

    context 'for not yet implemented message types' do
      let(:initial_payload) do
        attributes = attributes_for(:text_message).merge(public_key: test_public_key)
        Threema::Send::E2EBase.new(attributes).send(:generate_payload, :geo, 'whatever')
      end

      it 'creates instance of type Threema::Receive::DeliveryReceipt' do
        expect(subject.call).to be_a(Threema::Receive::NotImplementedFallback)
      end
    end
  end
end
