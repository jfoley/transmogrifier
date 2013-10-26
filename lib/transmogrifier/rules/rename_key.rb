require "transmogrifier/rules/base"
module Transmogrifier
  module Rules
    class RenameKey < Base
      def initialize(from, to)
        @from = from
        @to = to
      end

      def apply!(match)
        match.slice[@to] = match.slice.delete(@from)
      end
    end
  end
end
