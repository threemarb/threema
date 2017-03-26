require 'spec_helper'
require 'json'

RSpec.describe Threema::Lookup do
  let(:instance) { build(:threema_lookup) }

  def mock_lookup(response)
    stub_request(:get, url)
      .with(query: test_auth_params)
      .to_return(
        status: 200,
        body:   response,
      )
  end

  it 'has URL_PATH (Hash) constant' do
    expect(described_class).to have_constant(:URL_PATH)
    expect(described_class::URL_PATH).to be_a(Hash)
  end

  it 'responds to url' do
    expect(described_class).to respond_to(:url)
  end

  it 'responds to filled_url' do
    expect(described_class).to respond_to(:filled_url)
  end

  context 'key' do
    let(:method_call) { instance.key(test_threema_id) }

    it 'responds to key' do
      expect(instance).to respond_to(:key)
    end

    it 'returns the Public Key for a Threema ID' do
      mock_pubkey(test_threema_id, test_public_key)
      expect(method_call).to eq(test_public_key)
    end

    it 'returns nil for an unknown key number' do
      mock_error(404)
      expect(method_call).to be_nil
    end

    context 'error responds' do
      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { method_call }.to raise_error(Unauthorized)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { method_call }.to raise_error(RemoteError)
      end
    end
  end

  context 'phone' do
    let(:phone) { '41791234567' }
    let(:url) { described_class.filled_url(:phone, phone) }
    let(:method_call) { instance.phone(phone) }

    it 'responds to phone' do
      expect(instance).to respond_to(:phone)
    end

    it 'returns the Threema ID for a phone number (E.164), without leading +' do
      mock_lookup(test_threema_id)
      expect(method_call).to eq(test_threema_id)
    end

    it 'returns nil for an unknown phone number' do
      mock_error(404)
      expect(method_call).to be_nil
    end

    context 'error responds' do
      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { method_call }.to raise_error(Unauthorized)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { method_call }.to raise_error(RemoteError)
      end
    end
  end

  context 'phone_hash' do
    let(:phone_hash) { 'ad398f4d7ebe63c6550a486cc6e07f9baa09bd9d8b3d8cb9d9be106d35a7fdbc' }
    let(:url) { described_class.filled_url(:phone_hash, phone_hash) }
    let(:method_call) { instance.phone_hash(phone_hash) }

    it 'responds to phone_hash' do
      expect(instance).to respond_to(:phone_hash)
    end

    it 'returns the Threema ID for a phone_hash' do
      mock_lookup(test_threema_id)
      expect(method_call).to eq(test_threema_id)
    end

    it 'returns nil for an unknown phone_hash' do
      mock_error(404)
      expect(method_call).to be_nil
    end

    context 'error responds' do
      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { method_call }.to raise_error(Unauthorized)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { method_call }.to raise_error(RemoteError)
      end
    end
  end

  context 'email' do
    let(:email) { 'test@threema.ch' }
    let(:url) { described_class.filled_url(:email, email) }
    let(:method_call) { instance.email(email) }

    it 'responds to email' do
      expect(instance).to respond_to(:email)
    end

    it 'returns the Threema ID for an email' do
      mock_lookup(test_threema_id)
      expect(method_call).to eq(test_threema_id)
    end

    it 'returns nil for an unknown email' do
      mock_error(404)
      expect(method_call).to be_nil
    end

    context 'error responds' do
      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { method_call }.to raise_error(Unauthorized)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { method_call }.to raise_error(RemoteError)
      end
    end
  end

  context 'email_hash' do
    let(:email_hash) { '1ea093239cc5f0e1b6ec81b866265b921f26dc4033025410063309f4d1a8ee2c' }
    let(:url) { described_class.filled_url(:email_hash, email_hash) }
    let(:method_call) { instance.email_hash(email_hash) }

    it 'responds to email_hash' do
      expect(instance).to respond_to(:email_hash)
    end

    it 'returns the Threema ID for an email_hash' do
      mock_lookup(test_threema_id)
      expect(method_call).to eq(test_threema_id)
    end

    it 'returns nil for an unknown email_hash' do
      mock_error(404)
      expect(method_call).to be_nil
    end

    context 'error responds' do
      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { method_call }.to raise_error(Unauthorized)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { method_call }.to raise_error(RemoteError)
      end
    end
  end

  context 'by' do
    let(:email_hash) { '1ea093239cc5f0e1b6ec81b866265b921f26dc4033025410063309f4d1a8ee2c' }
    let(:url) { described_class.filled_url(:email_hash, email_hash) }
    let(:method_call) { instance.by(:email_hash, email_hash) }

    it 'responds to by' do
      expect(instance).to respond_to(:by)
    end

    it 'returns the Threema ID for a given type' do
      mock_lookup(test_threema_id)
      expect(method_call).to eq(test_threema_id)
    end

    it 'returns nil for an unknown type value' do
      mock_error(404)
      expect(method_call).to be_nil
    end

    it 'raises an ArgumentError exception for unknown types' do
      expect { instance.by(:rubberduck, 'john doe') }.to raise_error(ArgumentError)
    end

    context 'error responds' do
      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { method_call }.to raise_error(Unauthorized)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { method_call }.to raise_error(RemoteError)
      end
    end
  end

  context 'bulk' do
    let(:url) { described_class.url(:bulk) }

    it 'responds to bulk' do
      expect(instance).to respond_to(:bulk)
    end

    it 'returns a list of looked up phone and email hashes' do
      params = {
        phone_hashes: %w(
          27b0e25b6091a0d527e0265e2b4669691f253fd7e4fdca4e82ad37cb1e2bcc32
          ebe6cf4cb497b626622ed7eca80dff38a766153cb820441c03cd2677976b3b6a
        ),
        email_hashes: %w(
          eca1f01b9fa1ae14ba9d2fe236cde235c0f7877e73173d13501635a63010ded5
          8bb29bd2b5e7b9ca317eb345fd1f7f9a1f7a0524369872b0dac2d903fdfe36e3
        )
      }
      payload = {
        phoneHashes: %w(
          27b0e25b6091a0d527e0265e2b4669691f253fd7e4fdca4e82ad37cb1e2bcc32
          ebe6cf4cb497b626622ed7eca80dff38a766153cb820441c03cd2677976b3b6a
        ),
        emailHashes: %w(
          eca1f01b9fa1ae14ba9d2fe236cde235c0f7877e73173d13501635a63010ded5
          8bb29bd2b5e7b9ca317eb345fd1f7f9a1f7a0524369872b0dac2d903fdfe36e3
        )
      }

      response = [
        {
          'phoneHash' => '27b0e25b6091a0d527e0265e2b4669691f253fd7e4fdca4e82ad37cb1e2bcc32',
          'identity'  => 'QRSTUVWX',
          'publicKey' => 'e58771baf2db70989d0724ef77ba6bf867d46aaa24fc2c3f8f0f144d89a6264b'
        },
        {
          'emailHash' => '8bb29bd2b5e7b9ca317eb345fd1f7f9a1f7a0524369872b0dac2d903fdfe36e3',
          'identity'  => 'JIKLMNOP',
          'publicKey' => '6a2bd9a0912d4ce0e5c6fc6c9b8ac14a8fdb6282a34c7e0f5fe57d57c54fb69f'
        }
      ]

      result = [
        {
          phone_hash: '27b0e25b6091a0d527e0265e2b4669691f253fd7e4fdca4e82ad37cb1e2bcc32',
          identity:   'QRSTUVWX',
          public_key: 'e58771baf2db70989d0724ef77ba6bf867d46aaa24fc2c3f8f0f144d89a6264b'
        },
        {
          email_hash: '8bb29bd2b5e7b9ca317eb345fd1f7f9a1f7a0524369872b0dac2d903fdfe36e3',
          identity:   'JIKLMNOP',
          public_key: '6a2bd9a0912d4ce0e5c6fc6c9b8ac14a8fdb6282a34c7e0f5fe57d57c54fb69f'
        }
      ]

      stub_request(:post, url)
        .with(
          query: test_auth_params,
          body:  payload.to_json,
        )
        .to_return(
          body:   response.to_json,
          status: 200,
        )
      expect(instance.bulk(params)).to eq(result)
    end
  end
end
