module Transmogrifier
  module Rules
    class Delete
      def initialize(parent_selector, selector_to_delete)
        @parent = parent_selector
        @to_delete = selector_to_delete
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        keys = Selector.from_string(@parent).keys
        nodes = top.all(keys)
        child_key = Selector.from_string(@to_delete).key

        nodes.each do |node|
          node.delete(child_key)
        end

        top.raw
      end
    end
  end
end
