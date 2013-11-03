module Transmogrifier
  class Node
    def self.for(obj)
      return obj if obj.kind_of?(Node)
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
    def initialize(hash)
      raise unless hash.is_a?(Hash)
      @hash = hash
    end

    def find_all(keys)
      first_key, *remaining_keys = keys

      if first_key.nil?
        [self]
      elsif first_key == "*"
        @hash.values.flat_map { |a| Node.for(a).find_all(remaining_keys) }
      elsif child = @hash[first_key]
        Node.for(child).find_all(remaining_keys)
      else
        []
      end
    end

    def delete(key)
      Node.for(@hash.delete(key))
    end

    def append(hash)
      @hash.merge!(hash)
    end

    def raw
      Hash[@hash.map { |k,v| [k, (v.respond_to?(:raw) ? v.raw : v)] }]
    end
  end

  class ArrayNode < Node
    def initialize(array)
      raise unless array.is_a?(Array)
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
      node = find_nodes(key).first
      Node.for(@array.delete(node))
    end

    def append(node)
      @array << Node.for(node).raw
    end

    def raw
      @array.map { |a| a.respond_to?(:raw) ? a.raw : a }
    end

    private
    def find_nodes(attributes)
      @array.select do |node|
        attributes.all? do |k, v|
          raw_node = node.respond_to?(:raw) ? node.raw : node
          raw_node[k] == v
        end
      end
    end
  end

  class ValueNode < Node
    def initialize(value)
      raise if value.is_a?(Hash) || value.is_a?(Array)
      @value = value
    end

    def raw
      @value
    end

    def find_all(keys)
      return [self] if keys.empty?
      raise "cannot find children of ValueNode satisfying non-empty selector #{keys}"
    end
  end
end