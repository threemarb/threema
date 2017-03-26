class Threema
  class Send
    class Simple
      RECEIVER = {
        threema_id: :to,
        phone:      :phone,
        email:      :email,
      }.freeze

      attr_reader :payload

      def initialize(params)
        initialize_payload(params)
      end

      private

      def initialize_payload(params)
        @payload = {}
        initialize_receiver_payload(params)
        initialize_text_payload(params)
      end

      def initialize_receiver_payload(params)
        return if RECEIVER.keys.any? do |param|
          next if !params[param]
          @payload[RECEIVER[param]] = params[param]
          true
        end
        raise ArgumentError, "One of the following parameters is required: #{RECEIVER.keys.join(', ')}"
      end

      def initialize_text_payload(params)
        @payload[:text] = params[:text]
        return if @payload[:text].present?
        raise ArgumentError, 'Parameter text is required'
      end
    end
  end
end
