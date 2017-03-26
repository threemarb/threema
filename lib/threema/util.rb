class Threema
  module Util
    class << self
      def hexify(string)
        string.unpack('H*').first
      end

      def unhexify(hex)
        [hex].pack('H*')
      end
    end
  end
end
