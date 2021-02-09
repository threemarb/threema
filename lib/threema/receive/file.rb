# frozen_string_literal: true

require 'json'
require 'threema/blob'
require 'threema/util'
require 'threema/send/file'
require 'threema/e2e/secret_key'

class Threema
  module Receive
    class File
      attr_reader :content, :mime_type, :name

      def initialize(content:, threema:, **)
        structure = JSON.parse(content)

        blob = Threema::Blob.new(threema: threema)

        download = blob.download(structure['b'])

        @content = Threema::E2e::SecretKey.decrypt(
          data: download,
          key: Threema::Util.unhexify(structure['k']),
          nonce: Threema::E2e::File::NONCE[:file],
        )

        @mime_type = structure['m']
        @name      = structure['n']
      end
    end
  end
end
