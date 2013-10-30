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

    def find(keys)
      raise NotImplementedError
    end

    def as_hash
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

      @children = {}

      hash.each do |key, value|
        @children[key] = Node.for(value)
      end
    end

    def find(keys)
      all(keys).first
    end

    def all(keys)
      return [self] if keys.empty?
      keys = keys.dup
      key = keys.shift

      if key == "*"
        if keys.empty?
          nodes = @children.values
        else
          nodes = @children.values.map {|a| a.all(keys) }
        end
      else
        child = @children[key]

        if keys.empty? || child.nil?
          nodes = [child]
        else
          nodes = [child.all(keys)]
        end
      end

      nodes.flatten.compact
    end


    def delete(key)
      @children.delete(key)
    end

    def append(hash)
      hash.each do |key, value|
        @children[key] = Node.for(value)
      end
    end

    def as_hash
      hash = {}
      @children.each do |key, value|
        hash[key] = value.as_hash
      end
      hash
    end
  end

  class ArrayNode < Node
    def initialize(array)
      raise unless array.is_a?(Array)
      @array = array.map do |element|
        Node.for(element)
      end
    end

    def find(keys)
      all(keys).first
    end

    def all(keys)
      return [self] if keys.empty?
      keys = keys.dup
      key = keys.shift

      if key == "*"
        nodes =  @array.map {|a| a.all(keys) }
      else
        nodes = find_nodes(key)
        if keys.any? && nodes.any?
          nodes = nodes.map { |x| x.all(keys) }
        end
      end

      nodes.flatten.compact
    end

    def delete(key)
      node = find_nodes(key).first
      @array.delete(node)
    end

    def append(node)
      @array << Node.for(node)
    end

    def as_hash
      @array.map(&:as_hash)
    end

    private
    def find_nodes(attributes)
      @array.select do |node|
        attributes.all? do |k, v|
          node.as_hash[k] == v
        end
      end
    end
  end

  class ValueNode < Node
    def initialize(value)
      raise if value.is_a?(Hash) || value.is_a?(Array)
      @value = value
    end

    def as_hash
      @value
    end
  end
end