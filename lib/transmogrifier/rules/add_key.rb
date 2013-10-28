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
        p match
        if match.parent.nil?
          match.value[@name] = @value
        else
          if match.value.is_a?(Array)
            match.value << {@name => @value}
          else
            match.parent[@name] = @value
          end
        end
      end
    end
  end
end
