require 'spec_helper'
require 'json'

RSpec.describe Threema::Receive do
  let(:test_date) { Time.now.to_i }

  context '.e2e' do
    it 'responds to e2e' do
      expect(described_class).to respond_to(:e2e)
    end

    it 'creates instance of Threema::Receive::Text for text messages' do
      attributes = attributes_for(:text_message)

      mock_pubkey(attributes[:threema_id], test_public_key)

      instance = Threema::Send::Text.new(attributes)

      payload = instance.payload

      payload[:from]      = test_from
      payload[:messageId] = test_message_id
      payload[:date]      = test_date

      mac = Threema::E2e::MAC.generate(
        payload:    payload,
        api_secret: test_api_secret,
      )

      payload[:mac] = mac

      created = described_class.e2e(
        payload:    payload,
        threema:    build(:threema),
        public_key: test_public_key
      )

      expect(created).to be_a(Threema::Receive::Text)
    end

    context 'required payload parameters' do
      it 'requires box parameter in payload' do
        instance = build(:text_message, public_key: test_public_key)
        payload  = instance.payload

        payload.delete(:box)

        expect do
          described_class.e2e(
            payload:    payload,
            threema:    build(:threema),
            public_key: test_public_key
          )
        end.to raise_error(ArgumentError)
      end

      it 'requires nonce parameter in payload' do
        instance = build(:text_message, public_key: test_public_key)
        payload  = instance.payload

        payload.delete(:nonce)

        expect do
          described_class.e2e(
            payload:    payload,
            threema:    build(:threema),
            public_key: test_public_key
          )
        end.to raise_error(ArgumentError)
      end

      it 'requires from parameter in payload' do
        instance = build(:text_message, public_key: test_public_key)
        payload  = instance.payload

        expect do
          described_class.e2e(
            payload:    payload,
            threema:    build(:threema),
            public_key: test_public_key
          )
        end.to raise_error(ArgumentError)
      end

      it 'requires messageId parameter in payload' do
        instance = build(:text_message, public_key: test_public_key)
        payload  = instance.payload

        payload[:from] = test_from

        expect do
          described_class.e2e(
            payload:    payload,
            threema:    build(:threema),
            public_key: test_public_key
          )
        end.to raise_error(ArgumentError)
      end

      it 'requires messageId parameter in payload' do
        instance = build(:text_message, public_key: test_public_key)
        payload  = instance.payload

        payload[:from]      = test_from
        payload[:messageId] = test_message_id

        expect do
          described_class.e2e(
            payload:    payload,
            threema:    build(:threema),
            public_key: test_public_key
          )
        end.to raise_error(ArgumentError)
      end
    end

    context 'errors' do
      it 'raises RuntimeError if mac parameter validation fails' do
        instance = build(:text_message, public_key: test_public_key)
        payload  = instance.payload

        # required params
        payload[:from]      = test_from
        payload[:messageId] = test_message_id
        payload[:date]      = test_date

        payload[:mac] = 'compromised'

        expect do
          described_class.e2e(
            payload:    payload,
            threema:    build(:threema),
            public_key: test_public_key
          )
        end.to raise_error(RuntimeError)
      end

      it 'raises ArgumentError if no public_key for sender could be found' do
        instance = build(:text_message, public_key: test_public_key)
        payload  = instance.payload

        # required params
        payload[:from]      = test_from
        payload[:messageId] = test_message_id
        payload[:date]      = test_date

        payload[:mac] = Threema::E2e::MAC.generate(
          payload:    payload,
          api_secret: test_api_secret,
        )

        mock_error(404)

        expect do
          described_class.e2e(
            payload: payload,
            threema: build(:threema),
          )
        end.to raise_error(RuntimeError)
      end
    end
  end
end
