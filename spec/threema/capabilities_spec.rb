# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe Threema::Capabilities do
  let(:instance) { build(:threema_capabilities) }

  it 'responds to url' do
    expect(described_class).to respond_to(:url)
  end

  context 'list' do
    let(:url) { described_class.url(test_threema_id) }
    let(:method_call) { instance.list(test_threema_id) }

    it 'responds to list' do
      expect(instance).to respond_to(:list)
    end

    it 'returns a list (Array of Symbols) of capabilities of the given Threema ID' do
      mock_capabilities(test_threema_id, 'image,text,video,audio,file')
      capabilities = %i[image text video audio file]
      expect(method_call).to eq(capabilities)
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
end
