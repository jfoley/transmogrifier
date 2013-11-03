module Transmogrifier
  class Node
    def self.for(obj)
      case obj
        when Hash
          HashNode.new(obj)
        when Array
          ArrayNode.new(obj)
        else
          ValueNode.new(obj)
      end
    end

    def initialize(obj)
      raise NotImplementedError
    end

    def raw
      raise NotImplementedError
    end

    def delete(key_or_name)
      raise NotImplementedError
    end

    def append(node)
      raise NotImplementedError
    end
  end

  class HashNode < Node
    extend Forwardable

    def initialize(hash)
      @hash = hash
    end

    def find_all(keys)
      first_key, *remaining_keys = keys

      if first_key.nil?
        [self]
      elsif child = @hash[first_key]
        Node.for(child).find_all(remaining_keys)
      else
        []
      end
    end

    def_delegator :@hash, :delete
    def_delegator :@hash, :merge!, :append
    def_delegator :@hash, :to_hash, :raw
  end

  class ArrayNode < Node
    extend Forwardable

    def initialize(array)
      @array = array
    end

    def find_all(keys)
      first_key, *remaining_keys = keys

      if first_key.nil?
        [self]
      elsif first_key == "*"
        @array.flat_map { |a| Node.for(a).find_all(remaining_keys) }
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

  class ValueNode < Node
    def initialize(value)
      @value = value
    end

    def find_all(keys)
      return [self] if keys.empty?
      raise "cannot find children of ValueNode satisfying non-empty selector #{keys}"
    end

    def raw
      @value
    end
  end
end
