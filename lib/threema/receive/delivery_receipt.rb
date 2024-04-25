# frozen_string_literal: true

require 'threema/util'

class Threema
  module Receive
    class DeliveryReceipt
      STATUS_TYPE_BYTE = {
        received: "\x01".b,
        read: "\x02".b,
        explicitly_acknowledged: "\x03".b,
        explicity_declined: "\x04".b
      }.freeze
      UNHEXIFIED_MESSAGE_ID_LENGTH = 8

      attr_reader :content, :message_ids

      def initialize(content:, **)
        @content = content

        return unless type_by(content).present?

        @message_ids = extract_message_ids(content)
        instance_variable_set("@#{type_by(content)}_at", Time.current)
        self.class.send(:attr_reader, "#{type_by(content)}_at")
      end

      private

      def type_by(content)
        STATUS_TYPE_BYTE.key(content.slice(0))
      end

      def extract_message_ids(content)
        type_removed = content.slice(1, content.length - 1)
        num_message_ids = content.length / UNHEXIFIED_MESSAGE_ID_LENGTH

        message_ids = []
        num_message_ids.times do |index|
          start_index = index.zero? ? index : (index * UNHEXIFIED_MESSAGE_ID_LENGTH)
          end_index = (index + 1) * UNHEXIFIED_MESSAGE_ID_LENGTH
          message_ids << Threema::Util.hexify(type_removed.slice(start_index, end_index))
        end
        message_ids
      end
    end
  end
end
