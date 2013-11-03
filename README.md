# Transmogrifier

Transmogrifier is a tool that allows you to migrate a hash from one schema to another. It works by specifying a set of rules to apply to the hash and then running them in order.

## Usage
Example usage:
```
old_hash = {"key" => "value", "extra_key" => nil }

engine = Transmogrifier::Engine.from_rules_array([
  { "type" => "delete", "selector" => "", "name" => "extra_key" }
])

new_hash = engine.run(old_hash)

# new hash => {"key" => "value"}
```

Transmogrifier supports several rules.

1. Move
2. Append
3. Delete

## Next steps
1. code organization
2. nesting
