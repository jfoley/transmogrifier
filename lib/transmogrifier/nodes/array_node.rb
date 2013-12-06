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

    def clone(key)
      matching_nodes = find_nodes(key)
      raise "Multiple nodes match #{key}, clone criteria ambiguous" if matching_nodes.length > 1

      Marshal.load(Marshal.dump(matching_nodes.first))
    end

    def delete(key)
      matching_nodes = find_nodes(key)
      deleted_nodes = matching_nodes.each { |n| @array.delete(n) }
      deleted_nodes.length > 1 ? deleted_nodes : deleted_nodes.first
    end

    def_delegator :@array, :<<, :append
    def_delegator :@array, :to_a, :raw

    private

    def find_nodes(attributes)
      return @array if attributes.empty?

      filtered = @array.clone
      attributes.each do |attr|
        case attr[0]
          when "="
            filtered.select! { |node| node.merge(Hash[*attr[1..-1]]) == node }
          when "!="
            filtered.reject! { |node| node.merge(Hash[*attr[1..-1]]) == node }
          else
            raise "Unsupported attribute filter #{attr.inspect}"
        end
      end
      filtered
    end
  end
end
