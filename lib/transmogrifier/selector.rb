module Transmogrifier
  class Selector
    def initialize(string)
      @keys = string.split(".").reject(&:empty?).map do |str|
        matches = str.scan(/\[(.*)\]/).flatten
        if matches.any?
          matches[0].split(",").map { |str| str.split("=")}
        else
          str
        end
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
