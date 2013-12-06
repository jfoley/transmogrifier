module Transmogrifier
  module Rules
    class Modify
      def initialize(parent_selector, pattern, replacement)
        @parent_selector, @pattern, @replacement = parent_selector, pattern, replacement
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        parent_keys = Selector.from_string(@parent_selector).keys

        parents = top.find_all(parent_keys)
        parents.each { |parent| parent.modify(@pattern, @replacement) }

        top.raw
      end
    end
  end
end
