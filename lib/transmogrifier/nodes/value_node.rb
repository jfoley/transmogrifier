require_relative "node"

module Transmogrifier
  class ValueNode < Node
    attr_reader :parent_node

    def initialize(value, parent_node=nil)
      @value = value
      @parent_node = parent_node
    end

    def find_all(keys)
      return [self] if keys.empty?
      raise "cannot find children of ValueNode satisfying non-empty selector #{keys}"
    end

    def modify(pattern, replacement)
      raise "Value is not modifiable using pattern matching" unless @value.respond_to?(:gsub)
      return @value.gsub!(Regexp.new(pattern), replacement)
    end

    def raw
      @value
    end
  end
end