require 'case_transform'

class Threema
  class Capabilities
    class << self
      def url(threema_id)
        Threema::Client.url("/capabilities/#{threema_id}")
      end
    end

    def initialize(threema:)
      @threema = threema
    end

    def list(threema_id)
      @threema.client.not_found_ok do
        response = @threema.client.get(self.class.url(threema_id))
        response.split(',').collect(&:to_sym)
      end
    end
  end
end
