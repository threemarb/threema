require 'spec_helper'

RSpec.describe Threema::E2e::Key do
  context '.generate_pair' do
    it 'responds to encode' do
      expect(described_class).to respond_to(:encode)
    end

    it 'encodes private keys' do
      encoded = described_class.encode(RbNaCl::PrivateKey.generate)
      expect(encoded).to be_a(String)
      expect(encoded).to start_with('private:')
    end

    it 'encodes private keys' do
      encoded = described_class.encode(RbNaCl::PrivateKey.generate.public_key)
      expect(encoded).to be_a(String)
      expect(encoded).to start_with('public:')
    end

    it 'throws an ArgumentError exception on unkonwn input' do
      expect { described_class.encode('unknown') }.to raise_error(ArgumentError)
    end
  end

  context '.generate_pair' do
    it 'responds to generate_pair' do
      expect(described_class).to respond_to(:generate_pair)
    end

    it 'returns a Hash containing :private and :public' do
      pair = described_class.generate_pair
      expect(pair).to be_a(Hash)
      expect(pair).to include(:public, :private)
    end
  end

  context '.hash' do
    it 'responds to hash' do
      expect(described_class).to respond_to(:hash)
    end

    it 'hashes phone numbers' do
      hashed = 'ad398f4d7ebe63c6550a486cc6e07f9baa09bd9d8b3d8cb9d9be106d35a7fdbc'
      expect(described_class.hash(:phone, '41791234567')).to eq(hashed)
    end

    it 'hashes emails' do
      hashed = '1ea093239cc5f0e1b6ec81b866265b921f26dc4033025410063309f4d1a8ee2c'
      expect(described_class.hash(:email, 'test@threema.ch')).to eq(hashed)
    end

    it 'raises an ArgumentError exception for unknown types' do
      expect { described_class.hash(:rubberduck, 'john doe') }.to raise_error(ArgumentError)
    end
  end
end
