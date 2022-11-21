# frozen_string_literal: true

class Threema
  class TypedMessage
    TYPE_BYTE = {
      text: "\x01".b,
      geo: "\x10".b, # NOT IMPLEMENTED YET
      video: "\x13".b, # NOT IMPLEMENTED YET
      audio: "\x14".b, # NOT IMPLEMENTED YET
      survey_meta: "\x15".b, # NOT IMPLEMENTED YET
      survey_state: "\x16".b, # NOT IMPLEMENTED YET
      file: "\x17".b,
      delivery_receipt: "\x80".b
    }.freeze

    class << self
      def type_by(byte)
        TYPE_BYTE.key(byte)
      end

      def byte_by(type)
        TYPE_BYTE[type]
      end
    end

    attr_reader :typed, :type, :message

    def initialize(typed: nil, type: nil, message: nil)
      if typed
        @typed = typed
        split
      elsif type && message
        @type    = type
        @message = message
        join
      else
        raise ArgumentError, 'Typed message needs either typed or type and message as parameters'
      end
    end

    private

    def split
      return if @type || @message

      @message = @typed.dup
      @type    = self.class.type_by(@message.slice!(0))
    end

    def join
      return if @typed

      @typed = "#{self.class.byte_by(@type)}#{@message}".b
    end
  end
end
