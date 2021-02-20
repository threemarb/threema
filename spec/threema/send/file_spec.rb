# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::Send::File do
  include FakeFS::SpecHelpers
  FakeFS::FileSystem.clone('.')

  def mock_pubkey_call
    mock_pubkey(test_threema_id, test_public_key)
  end

  def mock_capabilities_call
    mock_capabilities(test_threema_id, 'file')
  end

  def mock_all
    mock_pubkey_call
    mock_capabilities_call
    mock_upload
  end

  context '#payload' do
    it 'responds to payload' do
      mock_all
      instance = build(:file_message)
      expect(instance).to respond_to(:payload)
    end

    it 'generates E2E payload structure' do
      mock_all
      instance = build(:file_message)
      payload  = instance.payload

      expect(payload).to include(
        to: a_string_matching(/.+/),
        nonce: a_string_matching(/.+/),
        box: a_string_matching(/.+/),
      )
    end

    context 'parameters' do
      it 'takes file path' do
        mock_all

        path = 'example.txt'
        File.write(path, hello_world)

        attributes = attributes_for(:file_message)
        attributes[:file] = path
        instance = described_class.new(attributes)

        payload  = instance.payload

        expect(payload).to include(
          to: a_string_matching(/.+/),
          nonce: a_string_matching(/.+/),
          box: a_string_matching(/.+/),
        )
      end

      context 'optional parameters' do
        it 'takes thumbnail parameter as bytestring' do
          mock_all

          attributes = attributes_for(:file_message)
          attributes[:thumbnail] = 'xxxx'.b
          instance = described_class.new(attributes)

          payload  = instance.payload

          expect(payload).to include(
            to: a_string_matching(/.+/),
            nonce: a_string_matching(/.+/),
            box: a_string_matching(/.+/),
          )
        end

        it 'takes thumbnail parameter as file path' do
          mock_all

          path = 'thumbnail.png'
          File.write(path, 'thisisanimage')

          attributes = attributes_for(:file_message)
          attributes[:thumbnail] = path
          instance = described_class.new(attributes)

          payload  = instance.payload

          expect(payload).to include(
            to: a_string_matching(/.+/),
            nonce: a_string_matching(/.+/),
            box: a_string_matching(/.+/),
          )
        end

        it 'takes public key parameter' do
          mock_capabilities_call
          mock_upload

          attributes = attributes_for(:file_message)
          attributes[:public_key] = test_public_key
          instance = described_class.new(attributes)

          payload  = instance.payload

          expect(payload).to include(
            to: a_string_matching(/.+/),
            nonce: a_string_matching(/.+/),
            box: a_string_matching(/.+/),
          )
        end
      end

      context 'required payload keys' do
        it 'requires Threema ID' do
          attributes = attributes_for(:file_message)
          attributes.delete(:threema_id)

          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end

        it 'requires file' do
          mock_pubkey_call
          mock_capabilities_call

          attributes = attributes_for(:file_message)
          attributes.delete(:file)

          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end

        it 'requires file to be a String' do
          mock_pubkey_call
          mock_capabilities_call

          attributes = attributes_for(:file_message)
          attributes[:file] = 5

          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
