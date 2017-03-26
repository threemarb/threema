require 'threema/util'

class Threema
  class Send
    class E2EBase
      attr_reader :payload

      def initialize(params)
        %i(threema threema_id).each do |required|
          value = params[required]
          raise ArgumentError, "Parameter #{required} is required." if !value
          instance_variable_set("@#{required}".to_sym, value)
        end

        public_key(params)
      end

      private

      def public_key(params)
        @public_key = params[:public_key] || lookup_key(@threema_id)
        return if @public_key
        raise "Can't find public key for Threema ID #{@threema_id}"
      end

      def generate_payload(type, message)
        typed_message = Threema::TypedMessage.new(
          message: message,
          type:    type,
        )

        nonce = Threema::E2e.nonce

        encrypted = Threema::E2e::PublicKey.encrypt(
          data:        add_padding(typed_message.typed),
          private_key: @threema.private_key,
          public_key:  @public_key,
          nonce:       nonce,
        )

        @payload = {
          to:    @threema_id,
          nonce: Threema::Util.hexify(nonce),
          box:   Threema::Util.hexify(encrypted)
        }
      end

      def add_padding(message)
        message + Threema::E2e.padding
      end

      def lookup_key(threema_id)
        lookup_instance.key(threema_id)
      end

      def lookup_instance
        @lookup_instance ||= Threema::Lookup.new(threema: @threema)
      end

      def check_capability(type)
        return if capable?(type)
        raise "Threema ID #{@threema_id} not capable of receiving #{type} messages."
      end

      def capable?(type)
        capabilities_instance.list(@threema_id).include?(type)
      end

      def capabilities_instance
        @capabilities_instance ||= Threema::Capabilities.new(threema: @threema)
      end
    end
  end
end
