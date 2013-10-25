module Transmogrifier
  module Rules
    class Base
      def initialize(selector)
        raise RuntimeError
      end

      def setup(selector, hash)
      end

      def apply!(hash)
        raise RuntimeError
      end
    end

    class AddKey < Base
      def initialize(name, value)
        @name = name
        @value = value
      end

      def setup(selector, hash)
        # mkdir
      end

      def apply!(hash)
        hash[@name] = @value
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

    class UpdateValue < Base
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