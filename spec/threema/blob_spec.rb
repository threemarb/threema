# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe Threema::Blob do
  include FakeFS::SpecHelpers

  FakeFS::FileSystem.clone('.')

  let(:instance) { build(:threema_blob) }

  def mock(status, response = {})
    stub_request(:get, url)
      .with(query: test_auth_params)
      .to_return(
        response.merge(status: status)
      )
  end

  it 'responds to url' do
    expect(described_class).to respond_to(:url)
  end

  it 'responds to download_url' do
    expect(described_class).to respond_to(:download_url)
  end

  context 'download' do
    let(:blob_id) { '53CRET31337' }
    let(:url) { described_class.download_url(blob_id) }
    let(:method_call) { instance.download(blob_id) }

    it 'responds to download' do
      expect(instance).to respond_to(:download)
    end

    it 'returns the downloaded binary string' do
      content = '1234567890'
      mock(200, body: content)
      expect(method_call).to eq(content)
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

  context 'upload' do
    let(:blob_id) { '53CRET31337' }
    let(:url) { described_class.url(:upload) }
    let(:content) { '0123456789' }
    let(:path) { 'example.txt' }
    let(:file) do
      File.write(path, content)
      File.open(path)
    end
    let(:filehandle_upload) { instance.upload(file) }

    it 'responds to upload' do
      expect(instance).to respond_to(:upload)
    end

    it 'uploads file from filehandle and returns a blob_id' do
      stub_request(:post, url)
        .with(
          query: test_auth_params,
          headers: {
            'Content-Type' => %r{multipart/form-data;}
          }
        )
        .to_return(
          status: 200,
          body: blob_id
        )

      expect(filehandle_upload).to eq(blob_id)
    end

    it 'uploads file from file path and returns a blob_id' do
      stub_request(:post, url)
        .with(
          query: test_auth_params,
          headers: {
            'Content-Type' => %r{multipart/form-data;}
          }
        )
        .to_return(
          status: 200,
          body: blob_id
        )

      File.write(path, content)
      expect(instance.upload(path)).to eq(blob_id)
    end

    context 'invalid parameters' do
      it 'throws an ArgumentError if parameter is blank' do
        expect { instance.upload('') }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError if parameter is not a String' do
        expect { instance.upload(5) }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError if file path is not readable' do
        expect { instance.upload('/this/will/never/exist') }.to raise_error(ArgumentError)
      end
    end

    context 'error responds' do
      it 'raises ArgumentError exception for HTTP BadRequest response' do
        mock_error(400)
        expect { filehandle_upload }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError exception for HTTP PayloadTooLarge response' do
        mock_error(413)
        expect { filehandle_upload }.to raise_error(ArgumentError)
      end

      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { filehandle_upload }.to raise_error(Unauthorized)
      end

      it 'tunnels CreditError exception on chargeable request with low credits' do
        mock_error(402)
        expect { filehandle_upload }.to raise_error(CreditError)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { filehandle_upload }.to raise_error(RemoteError)
      end

      it 'tunnels all other Exceptions' do
        mock_error(404)
        expect { filehandle_upload }.to raise_error(RequestError)
      end
    end
  end
end
