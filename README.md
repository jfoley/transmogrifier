# Transmogrifier

[![Build Status](https://travis-ci.org/jfoley/transmogrifier.png)](https://travis-ci.org/jfoley/transmogrifier)

Transmogrifier is a tool that allows you to decalaritively migrate a hash from one schema to another. It works by specifying a set of rules to apply to the hash and then running them in order.

## Usage
### Available Rules
#### Appending a node
```ruby
engine = Transmogrifier::Engine.new
append = Transmogrifier::Rules::Append.new("", { "new_key" => "new_value" })

engine.add_rule(append)

input_hash = {"key" => "value"}
output_hash = engine.run(input_hash)

# output_hash => {"key" => "value", "new_key" => "new_value"}
```

### Updating a node
```ruby
engine = Transmogrifier::Engine.new
update = Transmogrifier::Rules::Update.new("nested.nested_key", "updated-value")

engine.add_rule(update)

input_hash = {"key" => "value", "nested" => {"nested_key" => "nested_value"}}
output_hash = engine.run(input_hash)

# output_hash => {"key" => "value", "nested" => {"nested_key" => "updated-value"}}
```

#### Copying a node
```ruby
engine = Transmogrifier::Engine.new
copy = Transmogrifier::Rules::Copy.new("", "key", "nested.nested_key2")

engine.add_rule(copy)

input_hash = {"key" => "value", "nested" => {"nested_key" => "nested_value"}}
output_hash = engine.run(input_hash)

# output_hash => {"key" => "value", "nested" => {"nested_key" => "nested_value", "nested_key2" => "value"}}
```
If the node to be copied does not exist, then this operation will no-op leaving the hash unchanged.

#### Deleting  a node
```ruby
engine = Transmogrifier::Engine.new
delete = Transmogrifier::Rules::Delete.new("", "extra_key")

engine.add_rule(delete)

input_hash = {"key" => "value", "extra_key" => "some_value"}
output_hash = engine.run(input_hash)

# output_hash => {"key" => "value"}
```

#### Modifying a node's value
```ruby
engine = Transmogrifier::Engine.new
move = Transmogrifier::Rules::Modify.new("key", "al", "og")

engine.add_rule(move)

input_hash = {"key" => "value"}
output_hash = engine.run(input_hash)

# output_hash => {"key" => "vogue"}
```

#### Moving a node
```ruby
engine = Transmogrifier::Engine.new
move = Transmogrifier::Rules::Move.new("", "key", "nested")

engine.add_rule(:move, "", "key", "nested")

input_hash = {"key" => "value", "nested" => {"nested_key" => "nested_value"}}
output_hash = engine.run(input_hash)

# output_hash => {"nested" => {"nested_key" => "nested_value", "key" => "value"}}
```

### Programmatically loading rules
Rules can be specified in ruby code, but they can also be loaded with an array.
```ruby
rules = [
  {
    "type" => "append",
    "selector" => "top",
    "object" => {"some" => "attributes"},
  },

  {
    "type" => "move",
    "selector" => "top",
    "from" => "key1",
    "to" => "key2",
  },

  {
    "type" => "delete",
    "selector" => "top",
    "name" => "key3",
  },
]

engine = Transmogrifier::Engine.from_rules_array(rules)


input_hash = {
  "top" => {
    "key1" => "value1",
    "key3" => "value2",
  },
}
output_hash = engine.run(input_hash)

# output_hash => 
# { 
#   "top" => {
#     "some" => "attributes",
#     "key2" => "value1",
#   },
# }
```

### Selectors
Selectors are a string of hash keys seperated by dots that tell the Engine where to apply a given rule. For example, given the following structure:
```ruby
{ 
  "key" => "value", 
  "nested" => {
    "second_level" => {
      "deep" => "buried_value",
    },
  },
}
```
the selector `nested.second_level.deep` will apply to `buried_value`. Rules can also be applied to hashes inside of an array. Given the structure:
```ruby
{ 
  "key" => "value", 
  "array" => [
    {"name" => "not me"},
    {"name" => "this one!"},
  ],
}
```
the hash with the name `this one!` can be operated on with `array.[name=this one!]` or `array.[name!=not me]`. Arrays can also wildcard match all children. For example to match both hashes in the array above, use the selector `array.[]`.
