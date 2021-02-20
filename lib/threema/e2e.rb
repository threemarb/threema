# frozen_string_literal: true

require 'rbnacl'

class Threema
  module E2e
    NONCE_SIZE = 24

    class << self
      def nonce
        RbNaCl::Random.random_bytes(NONCE_SIZE)
      end

      def padding
        random_number = Random.new.rand(1...255)
        padding_list  = [random_number] * random_number
        padding_list.pack('c*')
      end

      def deflate(message)
        padding_length = message[-1].unpack1('C')
        message[0...-padding_length]
      end
    end
  end
end

# load after class definition since some rely on NONCE_SIZE constant
require 'threema/e2e/key'
require 'threema/e2e/file'
require 'threema/e2e/image'
require 'threema/e2e/mac'
require 'threema/e2e/public_key'
require 'threema/e2e/secret_key'
