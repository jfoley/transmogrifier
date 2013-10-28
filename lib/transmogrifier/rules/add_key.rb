require "transmogrifier/rules/base"

module Transmogrifier
  module Rules
    class AddKey < Base
      def initialize(name, value)
        @name = name
        @value = value
      end

      def setup(selector, key_path)
        key_path.mkdir(selector)
        super
      end

      def apply!(match)
        #sub_matches = KeyPath.new(match.value).find(@name)
        #sub_matches.each do |sub_match|
        #  p sub_match
        #  sub_match.value[@name] = @value
        #end
        #if match.value[@name].is_a?(Hash)
        #  match.value[@name].merge!(@value)
        #else
        #  match.value[@name] = @value
        #end

        #append_to = match.parent || match.value

        if match.parent.nil?
          match.value[@name] = @value
        else
          if match.value.is_a?(Array)   # TODO: untested
            match.value << {@name => @value}
          elsif match.value.is_a?(Hash)
            match.value.merge!(@name => @value)
          else
            match.parent[@name] = @value
          end
        end
      end
    end
  end
end
