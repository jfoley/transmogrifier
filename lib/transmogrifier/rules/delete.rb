module Transmogrifier
  module Rules
    class Delete
      def initialize(parent_selector, selector_to_delete)
        @parent_selector, @selector_to_delete = parent_selector, selector_to_delete
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        parent_keys = Selector.from_string(@parent_selector).keys
        child_key = Selector.from_string(@selector_to_delete).keys.first

        parents = top.find_all(parent_keys)
        parents.each { |parent| parent.delete(child_key) }

        top.raw
      end
    end
  end
end
