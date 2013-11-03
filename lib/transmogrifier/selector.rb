module Transmogrifier
  class Selector
    FILTER_REGEX = /\[(.*)\]/

    def self.from_string(string)
      new(
        string.split(".").map do |str|
          match = str.scan(FILTER_REGEX).flatten.first
          match ? match.split(",").map { |s| s.split("=") } : str
        end
      )
    end

    attr_reader :keys

    def initialize(keys)
      @keys = keys
    end
  end
end
