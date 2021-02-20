# frozen_string_literal: true

require 'threema/send/e2e_base'

class Threema
  class Send
    class E2EUpload < Threema::Send::E2EBase
      def initialize(params)
        super
        check_capability(self.class.name.split('::').last.downcase.to_sym)
      end

      private

      def validate_param(key, parameter)
        return if parameter.is_a?(String)

        raise ArgumentError, "Parameter '#{key}' has to be a file path or byte string."
      end

      def byte_string(key, file)
        validate_param(key, file)

        # should be a byte string
        return file if !::File.exist?(file)

        before_binread(file)
        ::File.binread(file)
      end

      def before_binread(_)
        # TODO: exception?
      end

      def blob_instance
        @blob_instance ||= Threema::Blob.new(threema: @threema)
      end

      def blob_id_for(encrypted)
        blob_instance.upload(StringIO.new(encrypted))
      end
    end
  end
end
