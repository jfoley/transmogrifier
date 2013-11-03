# Transmogrifier

Transmogrifier is a tool that allows you to decalaritively migrate a hash from one schema to another. It works by specifying a set of rules to apply to the hash and then running them in order.

## Usage
### Available Rules
#### Appending a key
```ruby
input_hash = {"key" => "value"}
transmogrifier = Transmogrifier::Engine.new
transmogrifier.add_rule(:append, "", "new_key", "new_value")
output_hash = transmogrifier.run(input_hash)

# output_hash => {"key" => "value", "new_key" => "new_value"}
```

#### Deleting  a key
```ruby
input_hash = {"key" => "value", "extra_key" => "some_value"}

transmogrifier = Transmogrifier::Engine.new
transmogrifier.add_rule(:delete, "", "extra_key")
output_hash = transmogrifier.run(input_hash)

# output_hash => {"key" => "value"}
```

#### Moving a key
```ruby
input_hash = {"key" => "value", "nested" => {"nested_key" => "nested_value"}}

transmogrifier = Transmogrifier::Engine.new
transmogrifier.add_rule(:move, "", "key", "nested")
output_hash = transmogrifier.run(input_hash)

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

input_hash = {
  "top" => {
    "key1" => "value1",
    "key3" => "value2",
  },
}

engine = Transmogrifier.load_rules(rules)
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
the hash with the name `this one!` can be operated on with `array.[name=this one!]`. Arrays can also wildcard match all children. For example to match both hashes in the array above, use the selector `array.[]`. 
