module Transmogrifier
  module Rules
    class Delete
      def initialize(parent_selector, selector_to_delete)
        @parent = parent_selector
        @to_delete = selector_to_delete
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        keys = Selector.new(@parent).keys
        nodes = top.all(keys)
        child_key = Selector.new(@to_delete).key

        nodes.each do |node|
          node.delete(child_key)
        end

        top.as_hash
      end
    end
  end
end
