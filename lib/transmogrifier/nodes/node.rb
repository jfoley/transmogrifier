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

    def clone(key_or_name)
      raise NotImplementedError
    end

    def delete(key_or_name)
      raise NotImplementedError
    end

    def append(node)
      raise NotImplementedError
    end
  end
end
