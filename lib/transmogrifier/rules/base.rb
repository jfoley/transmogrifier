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
  end
end
