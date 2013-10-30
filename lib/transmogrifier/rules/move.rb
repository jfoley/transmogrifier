module Transmogrifier
  module Rules
    class Move
      def initialize(parent_selector, from, to)
        @parent = parent_selector
        @from = from
        @to = to
      end

      def apply!(input_hash)
        top = Node.for(input_hash)

        parents = top.all(Selector.new(@parent).keys)

        parents.each do |parent|
          keys = Selector.new(@from).keys
          from_key = keys.pop

          from_parent = parent.find(keys.dup)

          deleted_object = from_parent.delete(from_key)

          keys = Selector.new(@to).keys
          to_parent = parent.find(keys.dup)

          if to_parent.nil?
            new_key = keys.pop
            to_parent = parent.find(keys)
            to_parent.append({new_key => deleted_object.as_hash})
          else
            to_parent.append(deleted_object.as_hash)
          end
        end



        top.as_hash
      end
    end
  end
end
