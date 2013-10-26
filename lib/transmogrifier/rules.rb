module Transmogrifier
  module Rules
    class Base
      def initialize(selector)
        raise RuntimeError
      end

      def setup(selector, key_path)
        key_path.hash
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

      def setup(selector, key_path)
        key_path.mkdir(selector)
        super
      end

      def apply!(match)
        match.value[@name] = @value
      end
    end

    class DeleteKey < Base
      def initialize(name)
        @name = name
      end

      def apply!(match)
        match.value.delete(@name)
      end
    end

    class RenameKey < Base
      def initialize(from, to)
        @from = from
        @to = to
      end

      def apply!(match)
        match.slice[@to] = match.slice.delete(@from)
      end
    end

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