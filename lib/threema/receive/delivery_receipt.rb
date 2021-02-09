class Threema
  module Receive
    class DeliveryReceipt
      attr_reader :content

      def initialize(content:, **)
        @content = content
      end
    end
  end
end
