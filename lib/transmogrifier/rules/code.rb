module Transmogrifier
  module Rules
    class Code
      def initialize(parent_selector, klass=nil)
        @parent_selector = parent_selector
        @klass = klass
      end

      def apply!(input_hash)
        @klass.new.apply!(selector: parent_selector, original_hash: input_hash)
      end

      private
      attr_reader :parent_selector
    end
  end
end
