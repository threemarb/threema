require 'openssl'

class Threema
  module E2e
    module MAC
      class << self
        def valid?(payload:, api_secret:)
          raise ArgumentError, "Missing attribute ':mac' in payload" if payload[:mac].nil?

          check_mac = generate(
            payload:    payload,
            api_secret: api_secret
          )
          payload[:mac] == check_mac
        end

        def generate(payload:, api_secret:)
          OpenSSL::HMAC.hexdigest('sha256', api_secret, concat(payload))
        end

        private

        def concat(payload)
          %i(from to messageId date nonce box).collect do |key|
            value = payload[key]
            raise ArgumentError, "Missing attribute '#{key}' in payload" if value.nil?
            value
          end.join
        end
      end
    end
  end
end
