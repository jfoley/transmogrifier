require_relative "node"

module Transmogrifier
  class ArrayNode < Node
    extend Forwardable

    def initialize(array)
      @array = array
    end

    def find_all(keys)
      first_key, *remaining_keys = keys

      if first_key.nil?
        [self]
      else
        find_nodes(first_key).flat_map { |x| Node.for(x).find_all(remaining_keys) }
      end
    end

    def delete(key)
      matching_nodes = find_nodes(key)
      raise "Multiple nodes match #{key}, deletion criteria ambiguous" if matching_nodes.length > 1
      @array.delete(matching_nodes.first)
    end

    def_delegator :@array, :<<, :append
    def_delegator :@array, :to_a, :raw

    private

    def find_nodes(attributes)
      @array.select { |node| node.merge(Hash[attributes]) == node }
    end
  end
end
