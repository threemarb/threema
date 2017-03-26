require 'spec_helper'
require 'base64'

RSpec.describe Threema::E2e::PublicKey do
  # don't bother, just for testing purposes
  let(:private_key) { '658779dd2a9af6e6c015336246441cfdce9435616df77fed1b9fa3945dba51fb' }
  let(:public_key) { '384b0c5e1f64054d92d229daefb0ebea7127db3983f2152e8683d2c1c6354c6f' }
  let(:nonce) { Base64.strict_decode64('SYngXXCOpp7sGUEpWqJbCf3OfDpbtZbk') }
  let(:encrypted_message) { Base64.strict_decode64('KOQhsvtYwG/KYxd9T/zYbCBfAhl51ZoWXBZf') }
  let(:decrypted_message) { hello_world }

  context '#encrypt' do
    it 'responds to encrypt' do
      expect(described_class).to respond_to(:encrypt)
    end

    it 'encrypts messages' do
      expect(
        described_class.encrypt(
          private_key: private_key,
          public_key:  public_key,
          nonce:       nonce,
          data:        decrypted_message,
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
          private_key: private_key,
          public_key:  public_key,
          nonce:       nonce,
          data:        encrypted_message,
        )
      ).to eq(decrypted_message)
    end
  end
end
