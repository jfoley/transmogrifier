module Transmogrifier
  module Rules
    class Delete
      def initialize(parent_selector, selector_to_delete)
        @parent = parent_selector
        @to_delete = selector_to_delete
      end

      def apply!(input_hash)
        top_level_node = Node.for(input_hash)
        keys = Selector.new(@parent).keys
        node = top_level_node.find(keys)

        child_key = Selector.new(@to_delete).key
        node.delete(child_key)

        top_level_node.as_hash
      end
    end
  end
end
