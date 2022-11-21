# frozen_string_literal: true

require 'threema/send/e2e_upload'
require 'threema/util'
require 'json'
require 'mimemagic'

class Threema
  class Send
    class File < Threema::Send::E2EUpload
      def initialize(params)
        super
        generate_payload(:file, JSON.generate(structure(params)))
      end

      private

      def structure(params)
        content = from(params)
        return content if !params[:thumbnail]

        content['t'] = thumbnail_blob_id(params)
        content['j'] = 1
        content
      end

      def from(params)
        byte_string = byte_string(:file, params[:file])

        encrypted = Threema::E2e::SecretKey.encrypt(
          key: secret_key,
          data: byte_string,
          nonce: Threema::E2e::File::NONCE[:file],
        )

        {
          'b' => blob_id_for(encrypted),
          'k' => Threema::Util.hexify(secret_key),
          'm' => params[:mime_type] || @mime_type.to_s || 'application/octet-stream',
          'n' => params[:file_name] || @file_name || 'unknown',
          's' => byte_string.size,
          'd' => params[:caption] || ''
        }
      end

      def thumbnail_blob_id(params)
        byte_string = byte_string(:thumbnail, params[:thumbnail])

        encrypted = Threema::E2e::SecretKey.encrypt(
          key: secret_key,
          data: byte_string,
          nonce: Threema::E2e::File::NONCE[:thumbnail],
        )

        blob_id_for(encrypted)
      end

      def secret_key
        @secret_key ||= Threema::E2e::SecretKey.generate
      end

      def before_binread(file)
        @file_name = ::File.basename(file)
        return if @file_name.blank?

        @mime_type = MimeMagic.by_magic(::File.open(file))&.type
      end
    end
  end
end
