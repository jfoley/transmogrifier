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
        if match.parent.nil?
          if match.value.is_a?(Hash)
            match.value.merge!(@name => @value)
          else
            match.value[@name] = @value
          end
        else
          if match.value.is_a?(Array)   # TODO: untested
            match.value << {@name => @value}
          elsif match.value.is_a?(Hash)
            match.value.merge!(@name => @value)
          else
            match.parent[@name] = @value
          end
        end
      end
    end
  end
end
