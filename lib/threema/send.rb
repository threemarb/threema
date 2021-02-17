require 'case_transform'
require 'threema/exceptions'
require 'threema/send/simple'
require 'threema/send/text'
require 'threema/send/image'
require 'threema/send/file'

class Threema
  class Send
    URL_PATH = {
      simple: '/send_simple',
      e2e:    '/send_e2e',
    }.freeze

    class << self
      def url(action)
        path = URL_PATH[action]
        raise ArgumentError, "Unknown action '#{action}'" if !path
        Threema::Client.url(path)
      end
    end

    def initialize(threema:)
      @threema = threema
    end

    def simple(params)
      message = Threema::Send::Simple.new(params)
      submit(:simple, message)
    rescue RequestError => e
      message = ''
      case e.message
      when 'Net::HTTPBadRequest'
        message = 'recipient identity is invalid or the account is not set up for basic mode'
      when 'Net::HTTPNotFound'
        message = 'the corresponding recipient for email/phone could not be found'
      else
        raise
      end

      raise ArgumentError, message
    end

    def text(params)
      message = Threema::Send::Text.new(params.merge(threema: @threema))
      e2e(message)
    end

    def image(params)
      message = Threema::Send::Image.new(params.merge(threema: @threema))
      e2e(message)
    end

    def file(params)
      message = Threema::Send::File.new(params.merge(threema: @threema))
      e2e(message)
    end

    private

    def e2e(message)
      submit(:e2e, message)
    rescue RequestError => e
      raise if e.message != 'Net::HTTPBadRequest'
      raise ArgumentError, 'recipient identity is invalid or the account is not set up for end-to-end mode'
    end

    def submit(type, message)
      @threema.client.chargeable do
        @threema.client.post_form_urlencoded(self.class.url(type), message.payload)
      end
    rescue RequestError => e
      raise if e.message != 'Net::HTTPPayloadTooLarge'
      raise ArgumentError, 'message is too long'
    end
  end
end
