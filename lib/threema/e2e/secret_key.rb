require 'rbnacl'

class Threema
  module E2e
    module SecretKey
      class << self
        def encrypt(key:, data:, nonce:)
          box(key).encrypt(nonce, data)
        end

        def decrypt(key:, data:, nonce:)
          box(key).decrypt(nonce, data)
        end

        def generate
          RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
        end

        private

        def box(key)
          RbNaCl::SecretBox.new(key)
        end
      end
    end
  end
end
