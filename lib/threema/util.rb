# frozen_string_literal: true

class Threema
  module Util
    class << self
      def hexify(string)
        string.unpack1('H*')
      end

      def unhexify(hex)
        [hex].pack('H*')
      end
    end
  end
end
