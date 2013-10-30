module Transmogrifier
  module Rules
    class Append
      def initialize(selector, hash)
        @selector = selector
        @hash = hash
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        keys = Selector.new(@selector).keys
        nodes = top.all(keys)
        nodes.each do |node|
          node.append(@hash)
        end

        top.as_hash
      end
    end
  end
end
