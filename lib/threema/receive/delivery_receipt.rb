# frozen_string_literal: true

require 'threema/util'

class Threema
  module Receive
    class DeliveryReceipt
      STATUS_BYTE_MAPPING = {
        received: "\x01".b,
        read: "\x02".b,
        explicitly_acknowledged: "\x03".b,
        explicity_declined: "\x04".b
      }.freeze
      UNHEXIFIED_MESSAGE_ID_LENGTH = 8

      attr_reader :content, :status, :timestamp, :message_ids

      def initialize(content:, **)
        @content = content
        @status = type_by(content)
        return unless @status

        @timestamp = Time.now.utc.to_i
        @message_ids = extract_message_ids(content.slice(1, content.length - 1))
      end

      private

      def type_by(content)
        STATUS_BYTE_MAPPING.key(content.slice(0))
      end

      def extract_message_ids(message_ids_payload)
        message_ids_payload.scan(/.{,#{UNHEXIFIED_MESSAGE_ID_LENGTH}}/).reject(&:empty?).map do |message_id|
          Threema::Util.hexify(message_id)
        end
      end
    end
  end
end
