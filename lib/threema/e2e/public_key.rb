# frozen_string_literal: true

require 'rbnacl'

class Threema
  module E2e
    module PublicKey
      class << self
        def encrypt(data:, private_key:, public_key:, nonce:)
          box(public_key, private_key).encrypt(nonce, data)
        end

        def decrypt(data:, private_key:, public_key:, nonce:)
          box(public_key, private_key).decrypt(nonce, data)
        end

        private

        def box(public_key, private_key)
          public_key_instance  = RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PublicKey.new(Threema::Util.unhexify(public_key))
          private_key_instance = RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PrivateKey.new(Threema::Util.unhexify(private_key))
          RbNaCl::Box.new(public_key_instance, private_key_instance)
        end
      end
    end
  end
end
