module Transmogrifier
  module Rules
    class Update
      def initialize(selector, new_value)
        @selector, @new_value = selector, new_value
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        *parent_keys, child_key = Selector.from_string(@selector).keys

        parents = top.find_all(parent_keys)
        raise SelectorNotFoundError, "#{parent_keys} does not select a node" unless parents.length > 0

        parents.each do |parent|
          if parent.class == HashNode
            raise SelectorNotFoundError, "no mapping for #{child_key} in parent node" unless parent.raw.has_key?(child_key)
            parent.append({child_key => @new_value})
          elsif parent.class == ArrayNode
            deleted_node = parent.delete(child_key)
            raise SelectorNotFoundError, "no node found with specified attributes" if deleted_node.nil?
            parent.append(@new_value)
          end
        end

        top.raw
      end
    end
  end
end
