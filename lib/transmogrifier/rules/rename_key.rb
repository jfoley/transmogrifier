require "transmogrifier/rules/base"
module Transmogrifier
  module Rules
    class RenameKey < Base
      def initialize(from, to)
        @from = from
        @to = to
      end

      def apply!(match)
        if match.parent.nil?
          match.value[@to] = match.value.delete(@from)
        else
          match.parent[@to] = match.parent.delete(@from)
        end

      end
    end
  end
end
