module Transmogrifier
  class SelectorNotFoundError < RuntimeError; end

  class Selector
    FILTER_REGEX = /\[(.*)\]/
    OPERATORS = ["!=", "="]

    def self.from_string(string)
      new(
        string.split(".").map do |str|
          match = str.scan(FILTER_REGEX).flatten.first
          match ? match.split(",").map {|s| to_array(s)}  : str
        end
      )
    end

    attr_reader :keys

    def initialize(keys)
      @keys = keys
    end

    private

    def self.to_array(string)
      OPERATORS.each do |op|
        next unless string.include?(op)
        return string.split(op).insert(0, op)
      end
      [string]
    end
  end
end
