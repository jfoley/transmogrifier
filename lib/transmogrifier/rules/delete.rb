module Transmogrifier
  module Rules
    class Delete
      def initialize(parent_selector, selector_to_delete)
        @parent_selector, @selector_to_delete = parent_selector, selector_to_delete
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        keys = Selector.from_string(@parent_selector).keys
        nodes = top.all(keys)
        child_key = Selector.from_string(@selector_to_delete).keys.first

        nodes.each { |node| node.delete(child_key) }

        top.raw
      end
    end
  end
end
