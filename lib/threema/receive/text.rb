class Threema
  module Receive
    class Text
      attr_reader :content

      def initialize(content:, **)
        @content = content
      end
    end
  end
end
