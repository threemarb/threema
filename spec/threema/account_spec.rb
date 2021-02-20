# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::Account do
  let(:instance) { build(:threema_account) }

  it 'has URL (Hash) constant' do
    expect(described_class).to have_constant(:URL)
    expect(described_class::URL).to be_a(Hash)
  end

  it 'responds to url' do
    expect(described_class).to respond_to(:url)
  end

  context 'credits' do
    let(:url) { described_class.url(:credits) }

    it 'returns the credits (Integer) for the used account' do
      credits = 1337

      stub_request(:get, url)
        .with(query: test_auth_params)
        .to_return(
          status: 200,
          body: credits.to_s,
        )

      expect(instance.credits).to eq(credits)
    end

    context 'error responds' do
      it 'tunnels Unauthorized exception on unauthorized request' do
        mock_error(401)
        expect { instance.credits }.to raise_error(Unauthorized)
      end

      it 'tunnels RemoteError exception on remote error request' do
        mock_error(500)
        expect { instance.credits }.to raise_error(RemoteError)
      end
    end
  end
end
