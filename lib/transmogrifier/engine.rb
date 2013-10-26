module Transmogrifier
  class Engine
    def initialize
      @selectors = {}
    end

    def add_rule(selector, rule)
      if @selectors.has_key?(selector)
        @selectors[selector] << rule
      else
        @selectors[selector] = [rule]
      end
    end

    def run(input_hash)
      output_hash = input_hash.dup

      @selectors.each do |selector, rules|
        rules.each do |rule|
          key_path = KeyPath.new(output_hash)

          output_hash = rule.setup(selector, key_path)

          key_path.modify(selector, &->(match){ rule.apply!(match) } )
        end
      end

      output_hash
    end
  end
end
