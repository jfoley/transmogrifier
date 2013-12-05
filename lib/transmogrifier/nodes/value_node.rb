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

    def modify(pattern, replacement)
      raise "Value is not modifiable using pattern matching" unless @value.respond_to?(:gsub)
      return @value.gsub!(Regexp.new(pattern), replacement)
    end

    def raw
      @value
    end
  end
end