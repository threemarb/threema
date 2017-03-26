require 'mime/types'
require 'threema/send/e2e_upload'
require 'threema/util'

class Threema
  class Send
    class Image < Threema::Send::E2EUpload
      MIME_TYPES = %w(image/jpg image/jpeg image/png).freeze

      def initialize(params)
        super
        generate_payload(:image, packed(params))
      end

      private

      def packed(params)
        # TODO: get type from class name?
        byte_string = byte_string(:image, params[:image])
        nonce       = Threema::E2e.nonce

        crypted_byte_string = Threema::E2e::PublicKey.encrypt(
          data:        byte_string,
          private_key: @threema.private_key,
          public_key:  @public_key,
          nonce:       nonce,
        )

        blob_id       = blob_id_for(crypted_byte_string)
        blob_id_bytes = Threema::Util.unhexify(blob_id)
        [blob_id_bytes, crypted_byte_string.size, nonce].pack(Threema::E2e::Image::FORMAT)
      end

      def before_binread(path)
        return if mime_type_allowed?(path)
        raise ArgumentError, "Invalid mime type for file '#{path}'. Allowed mime types are: #{MIME_TYPES.join(', ')}"
      end

      def mime_type_allowed?(path)
        extension = ::File.extname(path)
        return false if extension.blank?
        possible_mime_types = MIME::Types.type_for(extension)
        possible_mime_types.any? do |possible_mime_type|
          MIME_TYPES.include?(possible_mime_type)
        end
      end
    end
  end
end
