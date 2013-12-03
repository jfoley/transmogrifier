module Transmogrifier
  module Rules
    class Copy
      def initialize(parent_selector, from, to)
        @parent_selector, @from, @to = parent_selector, from, to
      end

      def apply!(input_hash)
        top = Node.for(input_hash)
        *from_keys, from_key = Selector.from_string(@from).keys
        *to_keys, to_key = Selector.from_string(@to).keys

        parents = top.find_all(Selector.from_string(@parent_selector).keys)
        parents.each do |parent|
          to_parent = parent.find_all(to_keys).first
          object = parent.find_all(from_keys).first.clone(from_key)

          if to_child = to_parent.find_all([to_key]).first
            to_child.append(object)
          else
            to_parent.append({to_key => object})
          end
        end

        top.raw
      end
    end
  end
end
