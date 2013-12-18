module Transmogrifier
  module Rules
    class Code
      def initialize(parent_selector, klass=nil)
        @klass = klass
      end

      def apply!(input_hash)
        @klass.new.apply!(input_hash)
      end
    end
  end
end
