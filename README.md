# counter_safe

Thread safe counters:
* [CounterSafe::Shared](src/counter_safe/shared.cr)       -- e.g.: global shared counters
* [CounterSafe::Exclusive](src/counter_safe/exclusive.cr) -- e.g.: class-local exclusive counters

Based on and with much thanks to: [Comparing Crystal’s concurrency with that of Go (Part II)](https://itnext.io/comparing-crystals-concurrency-with-that-of-go-part-ii-89049701b1a5)

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  counter_safe:
    github: drhuffman12/counter_safe
```

2. Run `shards install`
  ... or `shards install --ignore-crystal-version`

## Usage

```crystal
require "counter_safe"
```

Example Usage:
* Shared counters:
```
cs1 = CounterSafe::Shared.new
cs2 = CounterSafe::Shared.new
(1..1000).each {
  rand < 0.25 ? spawn cs1.inc("someKey") : spawn cs2.inc("someKey")
}

sleep 1.second
puts cs1.value("someKey")
puts cs2.value("someKey") #=> Should be the same as 'cs1.value("someKey")'
```

* Exclusive counters:
```
ce1 = CounterSafe::Exclusive.new
ce2 = CounterSafe::Exclusive.new
(1..1000).each {
  rand < 0.25 ? spawn ce1.inc("someKey") : spawn ce2.inc("someKey")
}
puts ce1.value("someKey")
puts ce2.value("someKey") #=> Should be DIFFERENT than as 'cs1.value("someKey")'
```

See also API doc's at: https://drhuffman12.github.io/counter_safe

## Development

REMINDER: Be sure to do separate PR's for:
(a) one or more PR(s) for 'regular' src/spec changes
```
# misc changes, then (before pushing your changes) run:
scripts/reformat
crystal spec
```

(b) followed by one PR for version bump and update docs
```
# bump version in `shards.yml`, then (before pushing your changes) run:
scripts/regen_docs
```


## Contributing

1. Fork it (<https://github.com/your-github-user/counter_safe/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Daniel Huffman](https://github.com/drhuffman12) - creator and maintainer
