module Transmogrifier
  module Rules
    class Append
      def initialize(selector, hash)
        @selector = selector
        @hash = hash
      end

      def apply!(input_hash)
        top_level_node = Node.for(input_hash)
        keys = Selector.new(@selector).keys
        node = top_level_node.find(keys)
        node.append(@hash)

        top_level_node.as_hash
      end
    end
  end
end
