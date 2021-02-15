require 'threema/blob'
require 'threema/util'
require 'threema/e2e'
require 'threema/e2e/image'
require 'threema/e2e/public_key'

class Threema
  module Receive
    class Image
      attr_reader :content

      def initialize(content:, threema:, public_key:)
        blob_id_bytes, crypted_byte_string_size, nonce = content.unpack(Threema::E2e::Image::FORMAT)

        blob_id  = Threema::Util.hexify(blob_id_bytes)
        blob     = Threema::Blob.new(threema: threema)
        download = blob.download(blob_id)

        @content = Threema::E2e::PublicKey.decrypt(
          data:        download,
          private_key: threema.private_key,
          public_key:  public_key,
          nonce:       nonce,
        )
      end
    end
  end
end
