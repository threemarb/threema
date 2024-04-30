# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::Client do
  it 'has API_URL constant' do
    expect(described_class).to have_constant(:API_URL)
  end

  it 'responds to url' do
    expect(described_class).to respond_to(:url)
  end

  let(:instance) { build(:threema_client, threema: threema) }
  let(:threema) { build(:threema) }

  context '#not_found_ok' do
    it 'responds to not_found_ok' do
      expect(instance).to respond_to(:not_found_ok)
    end

    it 'allows 404 responses' do
      mock_error(404)
      expect(
        instance.not_found_ok do
          instance.get(described_class::API_URL)
        end
      ).to be nil
    end

    it 'tunnels other exeptions' do
      mock_error(400)
      expect do
        instance.not_found_ok do
          instance.get(described_class::API_URL)
        end
      end.to raise_error(RequestError)
    end
  end

  describe '#configure' do
    subject { -> { instance.get(url) } }
    context 'with static certificate pinning' do
      let(:public_key_pinning) { true }

      before(:all) do
        WebMock.allow_net_connect!
      end

      after(:all) do
        WebMock.disable_net_connect!
      end

      before(:each) do
        instance.configure do |config|
          # Threema API fingerprint as of 2024-04-30
          fingerprint = '317bc8626c34a2ccd9052164828f4eb71a6bc6290e2569acee5b3a2cbde13d2a'

          # See: http://stackoverflow.com/a/22108461
          config.use_ssl = true

          config.verify_mode = OpenSSL::SSL::VERIFY_PEER

          config.verify_callback = lambda do |preverify_ok, cert_store|
            return false unless preverify_ok

            end_cert = cert_store.chain[0]
            return true unless end_cert.to_der == cert_store.current_cert.to_der
            return true unless public_key_pinning

            remote_fingerprint = OpenSSL::Digest::SHA256.hexdigest(end_cert.to_der)
            remote_fingerprint == fingerprint
          end
        end
      end

      # this is needed due to internet access restrictions
      # in the (travis) CI environment
      if !ENV['CI']
        context 'given Threema Message API URL with matching certificate' do
          let(:url) { described_class::API_URL }
          it 'checks HTTP Public Key Pinning' do
            should raise_error(RequestError)
            # not OpenSSL::SSL::SSLError
          end
        end
      end

      context 'given another URL without matching certificate' do
        let(:url) { 'https://github.com/threemarb/threema' }
        it { should raise_error(OpenSSL::SSL::SSLError) }

        context 'but if static certificate pinning is disabled' do
          let(:public_key_pinning) { false }
          it { should_not raise_error }
        end
      end
    end
  end

  context 'error responds' do
    it 'throws Unauthorized exception on 401 responds' do
      mock_error(401)
      expect { instance.get(described_class::API_URL) }.to raise_error(Unauthorized)
    end

    it 'throws RemoteError exception on 500 responds' do
      mock_error(500)
      expect { instance.get(described_class::API_URL) }.to raise_error(RemoteError)
    end

    it 'throws RequestError exception on other failure responds' do
      mock_error(402)
      expect { instance.get(described_class::API_URL) }.to raise_error(RequestError, /Net::HTTPPaymentRequired/)
    end
  end
end
