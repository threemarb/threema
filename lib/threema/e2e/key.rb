require 'rbnacl'
require 'openssl'
require 'threema/util'

class Threema
  module E2e
    # handles Threema key actions
    module Key
      KEYS = {
        phone: Threema::Util.unhexify('85adf8226953f3d96cfd5d09bf29555eb955fcd8aa5ec4f9fcd869e258370723'),
        email: Threema::Util.unhexify('30a5500fed9701fa6defdb610841900febb8e430881f7ad816826264ec09bad7'),
      }.freeze

      class << self
        def encode(nacl_key)
          type = nil
          if nacl_key.is_a?(RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PrivateKey)
            type = :private
          elsif nacl_key.is_a?(RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PublicKey)
            type = :public
          else
            raise ArgumentError, "Unknown key type: #{nacl_key}"
          end

          key = RbNaCl::Util.bin2hex(nacl_key.to_bytes)

          "#{type}:#{key}"
        end

        def hash(type, message)
          key = KEYS[type]
          raise ArgumentError, "Unknown type '#{type}'" if !key
          OpenSSL::HMAC.hexdigest('sha256', KEYS[type], message)
        end

        def generate_pair
          private_key = RbNaCl::PrivateKey.generate
          public_key  = private_key.public_key

          {
            private: private_key,
            public:  public_key
          }
        end
      end
    end
  end
end
