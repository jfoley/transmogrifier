require "transmogrifier/rules/base"

module Transmogrifier
  module Rules
    class MoveKey < Base
      def initialize(from, to)
        @from = from
        @to = to
      end

      def apply!(match)
        #p match
        delete = DeleteKey.new(@from)
        value = delete.apply!(match)

        sub_matches = KeyPath.new(match.parent).find(@to).each do |sub_match|
          AddKey.new(@from, value).apply!(sub_match)
        end
      end
    end
  end
end
