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
          rule.setup(selector, output_hash)

          key_path = KeyPath.new(output_hash)
          key_path.modify(selector, &->(sub_hash){ rule.apply!(sub_hash) } )
        end
      end

      output_hash
    end
  end
end
