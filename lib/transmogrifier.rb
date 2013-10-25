require "transmogrifier/version"

module Transmogrifier
  class Transmogrifier
    def initialize
      @rules = []
    end

    def add_rule(rule)
      @rules << rule
    end

    def transmogrify(input_hash)
      transformed_hash = input_hash.dup

      @rules.each do |rule|
        rule.apply!(transformed_hash)
      end

      transformed_hash
    end
  end

  module Rules
    class Base
      def initialize
        raise RuntimeError
      end

      def apply!(hash)
        raise RuntimeError
      end
    end

    class RenameKey < Base
      def initialize(from, to)
        @from = from
        @to = to
      end

      def apply!(hash)
        hash[@to] = hash.delete(@from)
        hash
      end
    end

    class AddKey < Base
      def initialize(name, default = nil)
        @name = name
        @default = default
      end

      def apply!(hash)
        hash[@name] = @default
        hash
      end
    end

    class DeleteKey < Base
      def initialize(name)
        @name = name
      end

      def apply!(hash)
        hash.delete(@name)
        hash
      end
    end

    class TransformValue < Base
      def initialize(key, value, new_value)
        @key = key
        @value = value
        @new_value = new_value
      end

      def apply!(hash)
        if hash[@key] == @value
          hash[@key] = @new_value
        end
        hash
      end
    end
  end
end
