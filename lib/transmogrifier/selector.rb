module Transmogrifier
  class Selector
    KEY_VALUE_REGEX = /\[(.*)=(.*)\]/

    def self.from_string(string)
      new(
        string.split(".").map do |str|
          match = str.scan(KEY_VALUE_REGEX).first
          match ? { match.first => match.last } : str
        end
      )
    end

    attr_reader :keys

    def initialize(keys)
      @keys = keys
    end
  end
end
