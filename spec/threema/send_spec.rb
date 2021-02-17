require 'spec_helper'
require 'json'

RSpec.describe Threema::Send do
  let(:instance) { build(:threema_send) }

  def stub_simple
    stub_request(:post, described_class.url(:simple))
  end

  def mock_simple(payload)
    stub_simple.with(
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      body: payload.merge(test_auth_params),
    )
               .to_return(
                 status: 200,
                 body:   test_message_id
               )
  end

  def mock_simple_error(code)
    stub_simple.to_return(status: code)
  end

  def mock_pubkey_call(threema_id)
    mock_pubkey(threema_id, test_public_key)
  end

  def stub_e2e
    stub_request(:post, Threema::Send.url(:e2e))
  end

  def mock_e2e(threema_id)
    stub_e2e.with(
      body: {
        'box' => /.+/,
        'nonce' => /.+/,
        'to'    => threema_id
      }.merge(test_auth_params)
    )
            .to_return(
              status: 200,
              body:   test_message_id
            )
  end

  it 'responds to url' do
    expect(described_class).to respond_to(:url)
  end

  context 'e2e messages' do
    it 'sends text message' do
      attributes = attributes_for(:text_message)
      mock_pubkey_call(attributes[:threema_id])

      mock_e2e(attributes[:threema_id])

      expect(instance.text(attributes)).to eq(test_message_id)
    end

    it 'sends file message' do
      attributes = attributes_for(:file_message)
      mock_pubkey_call(attributes[:threema_id])
      mock_capabilities(attributes[:threema_id], 'file')
      mock_upload

      mock_e2e(attributes[:threema_id])

      expect(instance.file(attributes)).to eq(test_message_id)
    end

    it 'sends image message' do
      attributes = attributes_for(:image_message)
      mock_pubkey_call(attributes[:threema_id])
      mock_capabilities(attributes[:threema_id], 'image')
      mock_upload

      mock_e2e(attributes[:threema_id])

      expect(instance.image(attributes)).to eq(test_message_id)
    end

    context 'error' do
      it 'raises ArgumentError if recipient identity is invalid or is not set up for end-to-end mode' do
        attributes = attributes_for(:text_message)
        mock_pubkey_call(attributes[:threema_id])

        stub_e2e.to_return(
          status: 400,
        )

        expect { instance.text(attributes) }.to raise_error(ArgumentError)
      end
    end
  end

  context 'simple' do
    it 'responds to simple' do
      expect(instance).to respond_to(:simple)
    end

    it 'sends to threema_id and returns the message ID' do
      mock_simple(
        to:   test_threema_id,
        text: hello_world,
      )

      expect(instance.simple(threema_id: test_threema_id, text: hello_world)).to eq(test_message_id)
    end

    it 'sends to phone and returns the message ID' do
      phone = '41791234567'

      mock_simple(
        phone: phone,
        text:  hello_world,
      )

      expect(instance.simple(phone: phone, text: hello_world)).to eq(test_message_id)
    end

    it 'sends to email and returns the message ID' do
      email = 'test@threema.ch'

      mock_simple(
        email: email,
        text:  hello_world,
      )

      expect(instance.simple(email: email, text: hello_world)).to eq(test_message_id)
    end

    it 'requires valid recipient identity parameter' do
      expect { instance.simple(rubberduck: 'john doe', text: hello_world) }.to raise_error(ArgumentError)
    end

    context 'error responds' do
      let(:method_call) { instance.simple(phone: '41791234567', text: hello_world) }

      it 'raises ArgumentError exception for HTTP BadRequest response' do
        mock_simple_error(400)
        expect { method_call }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError exception for HTTP PayloadTooLarge response' do
        mock_simple_error(413)
        expect { method_call }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError exception for HTTP NotFound response' do
        mock_simple_error(404)
        expect { method_call }.to raise_error(ArgumentError)
      end

      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_simple_error(401)
        expect { method_call }.to raise_error(Unauthorized)
      end

      it 'tunnels CreditError exception on chargeable request with low credits' do
        mock_simple_error(402)
        expect { method_call }.to raise_error(CreditError)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_simple_error(500)
        expect { method_call }.to raise_error(RemoteError)
      end

      it 'tunnels RequestError on other HTTP request errors' do
        mock_simple_error(408)
        expect { method_call }.to raise_error(RequestError)
      end
    end
  end
end
