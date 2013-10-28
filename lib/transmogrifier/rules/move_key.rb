require "transmogrifier/rules/base"

module Transmogrifier
  module Rules
    class MoveKey < Base
      def initialize(from, to)
        @from = from
        @to = to
      end

      def apply!(match)
        delete = DeleteKey.new(@from)
        value = delete.apply!(match)
        AddKey.new(@to, @from => value).apply!(match)
      end
    end
  end
end
