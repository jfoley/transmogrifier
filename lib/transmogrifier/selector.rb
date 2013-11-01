module Transmogrifier
  class Selector
    KEY_VALUE_REGEX = /\[(.*)=(.*)\]/

    def self.from_string(string)
      keys = string.split(".").map do |str|
        match = str.scan(KEY_VALUE_REGEX).first
        match ? { match.first => match.last } : str
      end
      new(keys)
    end

    attr_reader :keys

    def initialize(keys)
      @keys = keys
    end

    def key
      @keys.first
    end
  end
end
