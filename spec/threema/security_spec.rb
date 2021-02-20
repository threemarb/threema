# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::E2e do
  it 'has constant NONCE_SIZE' do
    expect(described_class).to have_constant(:NONCE_SIZE)
  end

  context '.nonce' do
    it 'responds to nonce' do
      expect(described_class).to respond_to(:nonce)
    end

    it 'generates random nonce' do
      expect(described_class.nonce).not_to eq(described_class.nonce)
    end
  end

  context '.padding' do
    it 'responds to padding' do
      expect(described_class).to respond_to(:padding)
    end

    it 'generates random padding' do
      expect(described_class.padding).not_to eq(described_class.padding)
    end

    it 'generates padding in range between 1 and 255 bytes' do
      expect(described_class.padding.bytesize).to be_between(1, 255)
    end
  end

  context '.deflate' do
    it 'responds to deflate' do
      expect(described_class).to respond_to(:deflate)
    end

    it 'removes padding from byte string' do
      byte_string = "#{hello_world}\a\a\a\a\a\a\a"
      expect(described_class.deflate(byte_string)).to eq(hello_world)
    end

    it 'removes added padding' do
      text   = hello_world
      padded = text + described_class.padding
      expect(described_class.deflate(padded)).to eq(text)
    end
  end
end
