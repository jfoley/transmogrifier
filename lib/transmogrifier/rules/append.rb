module Transmogrifier
  module Rules
    class Append
      def initialize(parent_selector, new_hash)
        @parent_selector, @hash = parent_selector, new_hash
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        parent_keys = Selector.from_string(@parent_selector).keys

        parents = top.find_all(parent_keys)
        parents.each { |parent| parent.append(@hash) }

        top.raw
      end
    end
  end
end
