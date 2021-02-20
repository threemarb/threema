# frozen_string_literal: true

require 'spec_helper'
require 'base64'

RSpec.describe Threema::E2e::SecretKey do
  # don't bother, just for testing purposes
  let(:secret_key) { Base64.strict_decode64('vQ9Cpf/mIDAF+h87D3uXhXMhkNQk1v54tPeuCjjAHIQ=') }
  let(:nonce) { Base64.strict_decode64('SYngXXCOpp7sGUEpWqJbCf3OfDpbtZbk') }
  let(:encrypted_message) { Base64.strict_decode64('kSisSfn0bNqdPB2VJZH2clWUUsUo8U0Y2wdf') }
  let(:decrypted_message) { hello_world }

  context '#encrypt' do
    it 'responds to encrypt' do
      expect(described_class).to respond_to(:encrypt)
    end

    it 'encrypts messages' do
      expect(
        described_class.encrypt(
          key: secret_key,
          data: decrypted_message,
          nonce: nonce,
        )
      ).to eq(encrypted_message)
    end
  end

  context '#decrypt' do
    it 'responds to decrypt' do
      expect(described_class).to respond_to(:decrypt)
    end

    it 'decrypts messages' do
      expect(
        described_class.decrypt(
          key: secret_key,
          nonce: nonce,
          data: encrypted_message,
        )
      ).to eq(decrypted_message)
    end
  end

  context '#generate' do
    it 'responds to generate' do
      expect(described_class).to respond_to(:generate)
    end

    it 'generates random secret keys' do
      expect(described_class.generate).not_to eq(described_class.generate)
    end
  end
end
