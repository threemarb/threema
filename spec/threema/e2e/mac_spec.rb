# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::E2e::MAC do
  # don't bother, just for testing purposes
  let(:api_secret) { '23892euiqwedj3r90434' }
  let(:payload) do
    {
      from: 'AAAAAAAA',
      to: 'ZZZZZZZZ',
      messageId: '1234567812345678',
      date: '1',
      nonce: '4882fed3973345c1779ce2ad975717b09f7bb7fc9e77f257',
      box: 'a2eff3530926c50a595212187e70b986245b22d7a8d04935595197c790dfe95e7f06184412c7fa34c2771e02b223537eb29d75b1b2f9603c936d68f677a0dfdf3c08dff29e763ff35b7595d0018c72ab9a6ea93942d64ba20dae502a43d20c7701165f45c37d8baa39ab440230f9a829dde34904b9592df5d5266363aab45098ac1e4f01babc32e93b85d9aabfe7b74e5119f392d21ca5648bc340bdac19ea89912706fd',
      mac: '83e9adda7ebba86da1d60e516c8d239aea44c678d81d1efdba3a78bbe484fc28'
    }
  end

  context '.generate' do
    it 'responds to generate' do
      expect(described_class).to respond_to(:generate)
    end

    it 'generates a mac from a payload structure' do
      mac = described_class.generate(
        payload: payload,
        api_secret: api_secret,
      )
      expect(mac).to eq payload[:mac]
    end

    it 'throws an ArgumentError on missing keys' do
      payload.delete(:from)

      expect do
        described_class.generate(
          payload: payload,
          api_secret: api_secret,
        )
      end.to raise_error(ArgumentError)
    end
  end

  context '.valid?' do
    it 'responds to valid?' do
      expect(described_class).to respond_to(:valid?)
    end

    it 'validates a payload structure' do
      validy = described_class.valid?(
        payload: payload,
        api_secret: api_secret,
      )
      expect(validy).to be true
    end

    it 'detects invalid payload structures' do
      validy = described_class.valid?(
        payload: payload.merge(mac: 'compromised'),
        api_secret: api_secret,
      )
      expect(validy).to be false
    end

    it 'throws an ArgumentError on missing mac generation keys' do
      payload.delete(:from)

      expect do
        described_class.valid?(
          payload: payload,
          api_secret: api_secret,
        )
      end.to raise_error(ArgumentError)
    end

    it 'throws an ArgumentError on missing mac' do
      payload.delete(:mac)

      expect do
        described_class.valid?(
          payload: payload,
          api_secret: api_secret,
        )
      end.to raise_error(ArgumentError)
    end
  end
end
