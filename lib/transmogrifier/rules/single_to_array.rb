require "transmogrifier/rules/base"

module Transmogrifier
  module Rules
    class SingleToArray < Base
      def initialize(key)
        @key = key
      end

      def apply!(match)
        match.slice[@key] = [match.slice[@key]]
      end
    end
  end
end
