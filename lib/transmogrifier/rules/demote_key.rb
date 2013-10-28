require "transmogrifier/rules/base"
module Transmogrifier
  module Rules
    class DemoteKey < Base
      def initialize(key, selector)
        @key = key
        @selector = selector
      end

      def apply!(match)
        p "demoted ", match
        demoted = match.parent.delete(@key)
        sub_matches = KeyPath.new(match.parent).find(@selector)
        sub_matches.each do |sub_match|
          sub_match.parent[@key] = demoted
        end
      end
    end
  end
end
