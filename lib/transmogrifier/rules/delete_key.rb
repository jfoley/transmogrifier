require "transmogrifier/rules/base"

module Transmogrifier
  module Rules
    class DeleteKey < Base
      def initialize(name)
        @name = name
      end

      def apply!(match)
        #p match
        match.value.delete(@name)
      end
    end
  end
end
