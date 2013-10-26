require "transmogrifier/rules/base"
module Transmogrifier
  module Rules
    class AddKey < Base
      def initialize(name, value)
        @name = name
        @value = value
      end

      def setup(selector, key_path)
        key_path.mkdir(selector)
        super
      end

      def apply!(match)
        match.value[@name] = @value
      end
    end
  end
end
