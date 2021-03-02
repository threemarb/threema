# frozen_string_literal: true

class Threema
  module Receive
    class NotImplementedFallback
      attr_reader :content

      def initialize(content:, **)
        @content = content
      end
    end
  end
end
