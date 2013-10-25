# Transmogrifier

Transmogrifier is a tool that allows you to migrate a hash from one schema to another. It works by specifying a set of rules to apply to the hash and then running them in order.

## Usage
Example usage:
```
old_hash = {"key" => "value", "extra_key" => nil }

transmogrifier = Transmogrifier::Transmogrifier.new
transmogrifier.add_rule(Transmogrifier::Rules::DeleteKey.new("extra_key"))
new_hash = transmogrifier.transmogrify!(old_hash)

# new hash => {"key" => "value"}
```

Transmogrifier supports several rules.

1. RenameKey
2. AddKey
3. DeleteKey
4. TransformValue

It is also intended to be easy to add your own rules by subclassing Rules::Base.

### Next steps
1. code organization
2. nesting
