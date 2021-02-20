# frozen_string_literal: true

require 'threema/send/e2e_base'
require 'threema/e2e'

class Threema
  class Send
    class Text < Threema::Send::E2EBase
      def initialize(params)
        super
        generate_payload(:text, params[:text])
      end
    end
  end
end
