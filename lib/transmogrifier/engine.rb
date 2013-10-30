module Transmogrifier
  class Engine
    def self.load_rules(rules_array)
      engine = new
      rules_array.each do |rule|
        type = rule.delete("type").to_sym
        selector = rule.delete("selector")
        options = [rule["object"], rule["from"], rule["to"], rule["name"]].compact
        engine.add_rule(type, selector, *options)
      end
      engine
    end

    def initialize
      @rules = []
    end

    def add_rule(rule_type, selector, *options)
      @rules << case rule_type
        when :append then Transmogrifier::Rules::Append.new(selector, *options)
        when :delete then Transmogrifier::Rules::Delete.new(selector, *options)
        when :move   then Transmogrifier::Rules::Move.new(selector, *options)
      end
    end

    def run(input_hash)
      output_hash = input_hash.dup
      @rules.each{ |rule| output_hash = rule.apply!(output_hash) }

      output_hash
    end
  end
end
