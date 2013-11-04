require_relative "node"

module Transmogrifier
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