module Transmogrifier
  class Engine
    def self.from_rules_array(rules_array)
      new(
        rules_array.map do |rule|
          type = rule["type"].capitalize
          selector = rule["selector"]
          options = [
            rule["object"],
            rule["from"],
            rule["to"],
            rule["name"],
            rule["pattern"],
            rule["replacement"],
          ].compact
          Transmogrifier::Rules.const_get(type).new(selector, *options)
        end
      )
    end

    def initialize(rules=[])
      @rules = rules
    end

    def add_rule(rule)
      @rules << rule
    end

    def run(input_hash)
      output_hash = input_hash.dup
      @rules.each { |rule| output_hash = rule.apply!(output_hash) }
      output_hash
    end
  end
end
