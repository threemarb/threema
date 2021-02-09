# frozen_string_literal: true

require 'case_transform'
require 'threema/e2e/mac'
require 'threema/typed_message'
require 'threema/lookup'
require 'threema/util'

require 'threema/receive/text'
require 'threema/receive/image'
require 'threema/receive/file'
require 'threema/receive/delivery_receipt'

class Threema
  module Receive
    class << self
      def e2e(payload:, threema:, public_key: nil)
        sanity_check(
          payload: payload,
          threema: threema,
        )

        public_key ||= public_key(
          payload: payload,
          threema: threema,
        )

        unwrapped = unwrap(
          payload: payload,
          threema: threema,
          public_key: public_key,
        )

        instanciate(
          threema: threema,
          unwrapped: unwrapped,
          public_key: public_key,
        )
      end

      private

      def instanciate(threema:, unwrapped:, public_key:)
        typed_message = Threema::TypedMessage.new(typed: unwrapped)

        type_instance(
          type: typed_message.type,
          params: {
            threema: threema,
            content: typed_message.message,
            public_key: public_key
          }
        )
      end

      def type_instance(type:, params:)
        classify(type).new(params)
      end

      def classify(type)
        Object.const_get(class_name(type))
      end

      def class_name(type)
        class_name = CaseTransform.camel(type.to_s)
        "Threema::Receive::#{class_name}"
      end

      def unwrap(payload:, threema:, public_key:)
        decrypted = decrypt(
          payload: payload,
          threema: threema,
          public_key: public_key,
        )

        # TODO: check if .to_s is really necessary
        Threema::E2e.deflate(decrypted.to_s)
      end

      def decrypt(payload:, threema:, public_key:)
        Threema::E2e::PublicKey.decrypt(
          private_key: threema.private_key,
          public_key: public_key,
          data: Threema::Util.unhexify(payload[:box]),
          nonce: Threema::Util.unhexify(payload[:nonce]),
        )
      end

      def sanity_check(payload:, threema:)
        %i[box nonce].each do |key|
          next if payload[key].present?

          raise ArgumentError, "Missing key '#{key}' in payload"
        end

        validate_mac(
          payload: payload,
          threema: threema,
        )
      end

      def validate_mac(payload:, threema:)
        return if Threema::E2e::MAC.valid?(
          payload: payload,
          api_secret: threema.api_secret,
        )

        raise "Invalid mac '#{payload[:mac]}' for payload"
      end

      def public_key(payload:, threema:)
        from = payload[:from]
        raise ArgumentError, "Missing key 'from' in payload" if from.blank?

        lookup = Threema::Lookup.new(threema: threema)
        public_key = lookup.key(from)
        return public_key if public_key.present?

        raise "Can't find public key for Threema ID '#{from}'"
      end
    end
  end
end
