require 'spec_helper'

RSpec.describe Threema::Send::Text do
  def mock_pubkey_call
    mock_pubkey(test_threema_id, test_public_key)
  end

  context '#payload' do
    it 'responds to payload' do
      mock_pubkey_call
      instance = build(:text_message)
      expect(instance).to respond_to(:payload)
    end

    it 'generates E2E payload structure' do
      mock_pubkey_call
      instance = build(:text_message)
      payload  = instance.payload

      expect(payload).to include(
        to:    a_string_matching(/.+/),
        nonce: a_string_matching(/.+/),
        box:   a_string_matching(/.+/),
      )
    end

    context 'required payload keys' do
      it 'requests public key' do
        mock_pubkey_call
        instance = build(:text_message)
        payload  = instance.payload

        expect(payload).to include(
          to:    a_string_matching(/.+/),
          nonce: a_string_matching(/.+/),
          box:   a_string_matching(/.+/),
        )
      end

      it 'takes public key parameter' do
        attributes = attributes_for(:text_message)
        attributes[:public_key] = test_public_key
        instance = described_class.new(attributes)
        payload  = instance.payload

        expect(payload).to include(
          to:    a_string_matching(/.+/),
          nonce: a_string_matching(/.+/),
          box:   a_string_matching(/.+/),
        )
      end

      it 'requires Threema ID' do
        attributes = attributes_for(:text_message)
        attributes.delete(:threema_id)
        expect { described_class.new(attributes) }.to raise_error(ArgumentError)
      end

      it 'requires text' do
        mock_pubkey_call
        attributes = attributes_for(:text_message)
        attributes.delete(:text)
        expect { described_class.new(attributes) }.to raise_error(ArgumentError)
      end
    end
  end
end
