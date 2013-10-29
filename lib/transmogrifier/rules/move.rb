module Transmogrifier
  module Rules
    class Move
      def initialize(parent_selector, from, to)
        @parent = parent_selector
        @from = from
        @to = to
      end

      def apply!(input_hash)
        top_level_node = Node.for(input_hash)

        keys = Selector.new(@parent).keys + Selector.new(@from).keys
        from_key = keys.pop
        node = top_level_node.find(keys.dup)

        deleted_object = node.delete(from_key)

        keys = Selector.new(@parent).keys + Selector.new(@to).keys

        node = top_level_node.find(keys.dup)

        if node.nil?
          new_key = keys.pop
          node = top_level_node.find(keys)
          node.append({new_key => deleted_object.as_hash})
        else
          node.append(deleted_object.as_hash)
        end

        top_level_node.as_hash
      end
    end
  end
end
