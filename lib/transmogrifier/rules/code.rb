module Transmogrifier
  module Rules
    class Code
      def initialize(parent_selector, klass, *extra_args)
        @parent_selector = parent_selector
        @klass = klass
        @extra_args = *extra_args
      end

      def apply!(input_hash)
        klass.new.apply!(selector: parent_selector, original_hash: input_hash, extra_args: extra_args)
      end

      private
      attr_reader :parent_selector, :klass, :extra_args
    end
  end
end
