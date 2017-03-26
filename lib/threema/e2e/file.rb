require 'securerandom'

class Threema
  module E2e
    module File
      NONCE = {
        file:      ("\x00".b * 23) + "\x01".b,
        thumbnail: ("\x00".b * 23) + "\x02".b,
      }.freeze
    end
  end
end
