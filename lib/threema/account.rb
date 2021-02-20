# frozen_string_literal: true

class Threema
  class Account
    URL = {
      credits: '/credits'
    }.freeze

    class << self
      def url(resource)
        Threema::Client.url(URL[resource])
      end
    end

    def initialize(threema:)
      @threema = threema
    end

    def credits
      @threema.client.get(self.class.url(:credits)).to_i
    end
  end
end
