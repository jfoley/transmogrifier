module Transmogrifier
  class Engine
    def self.from_rules_array(rules_array, migrators=[])
      migrator_map = migrators.reduce({}) do |memo, migrator|
        memo[migrator.name] = migrator
        memo
      end
      new(
        rules_array.map do |rule|
          type = rule["type"].capitalize
          selector = rule["selector"]
          options = [
            retrieve_migrator(rule["migrator"], migrator_map),
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

    private
    def self.retrieve_migrator(migrator_name, migrators)
      return nil if migrator_name.nil?

      raise "Unknown Migrator #{migrator_name}" unless migrators[migrator_name]
      migrators[migrator_name]
    end
  end
end
