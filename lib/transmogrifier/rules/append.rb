module Transmogrifier
  module Rules
    class Append
      def initialize(selector, hash)
        @selector, @hash = selector, hash
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        keys = Selector.from_string(@selector).keys
        nodes = top.find_all(keys)

        nodes.each { |node| node.append(@hash) }

        top.raw
      end
    end
  end
end
