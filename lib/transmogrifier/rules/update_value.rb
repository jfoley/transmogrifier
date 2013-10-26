require "transmogrifier/rules/base"

module Transmogrifier
  module Rules
    class UpdateValue < Base
      def initialize(key, value, new_value)
        @key = key
        @value = value
        @new_value = new_value
      end

      def apply!(match)
        if match.value[@key] == @value
          match.value[@key] = @new_value
        end
      end
    end
  end
end
