require "transmogrifier/version"
require "transmogrifier/key_path"

module Transmogrifier
  class Transmogrifier
    def initialize
      @selectors = {}
    end

    def add_rule(selector, rule)
      if @selectors.has_key?(selector)
        @selectors[selector] << rule
      else
        @selectors[selector] = [rule]
      end
    end

    def transmogrify(input_hash)
      transformed_hash = input_hash.dup

      @selectors.each do |selector, rules|
        rules.each do |rule|
          key_path = KeyPath.new(transformed_hash)
          key_path.modify(selector, &->(sub_hash){ rule.apply!(sub_hash) } )
        end
      end

      transformed_hash
    end
  end

  module Rules
    class Base
      def initialize(selector)
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
