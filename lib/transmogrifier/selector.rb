module Transmogrifier
  class Selector
    def initialize(string)
      @keys = string.split(".").reject(&:empty?).map do |str|
        matches = str.scan(/\[(.*)=(.*)\]/).flatten
        matches.any? ? {matches[0] => matches[1]} : str
      end
    end

    def key
      keys.first
    end

    def keys
      @keys
    end
  end
end