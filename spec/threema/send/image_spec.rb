# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::Send::Image do
  include FakeFS::SpecHelpers
  FakeFS::FileSystem.clone('.')

  def mock_pubkey_call
    mock_pubkey(test_threema_id, test_public_key)
  end

  def mock_capabilities_call
    mock_capabilities(test_threema_id, 'image')
  end

  def mock_all
    mock_pubkey_call
    mock_capabilities_call
    mock_upload
  end

  context '#payload' do
    it 'responds to payload' do
      mock_all
      instance = build(:image_message)
      expect(instance).to respond_to(:payload)
    end

    it 'generates E2E payload structure' do
      mock_all
      instance = build(:image_message)
      payload  = instance.payload

      expect(payload).to include(
        to: a_string_matching(/.+/),
        nonce: a_string_matching(/.+/),
        box: a_string_matching(/.+/),
      )
    end

    context 'parameters' do
      it 'takes image path' do
        mock_all

        path = 'image.png'
        File.write(path, 'imagecontent'.b)

        attributes = attributes_for(:image_message)
        attributes[:image] = path
        instance = described_class.new(attributes)

        payload  = instance.payload

        expect(payload).to include(
          to: a_string_matching(/.+/),
          nonce: a_string_matching(/.+/),
          box: a_string_matching(/.+/),
        )
      end

      context 'optional parameters' do
        it 'takes public key parameter' do
          mock_capabilities_call
          mock_upload

          attributes = attributes_for(:image_message)
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
          attributes = attributes_for(:image_message)
          attributes.delete(:threema_id)

          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end

        it 'requires image' do
          mock_pubkey_call
          mock_capabilities_call

          attributes = attributes_for(:image_message)
          attributes.delete(:image)

          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end

        it 'requires image to be a String' do
          mock_pubkey_call
          mock_capabilities_call

          attributes = attributes_for(:image_message)
          attributes[:image] = 5

          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end

        it 'image path has to be a supported MIME type' do
          mock_all

          path = 'image.txt'
          File.write(path, hello_world)

          attributes = attributes_for(:image_message)
          attributes[:image] = path
          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
