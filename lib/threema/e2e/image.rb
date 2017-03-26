require 'threema/blob'
require 'threema/e2e'

class Threema
  module E2e
    module Image
      FORMAT = "a#{Threema::Blob::ID_SIZE}Ia#{Threema::E2e::NONCE_SIZE}".freeze
    end
  end
end
