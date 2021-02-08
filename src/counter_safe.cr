require "./counter_safe/*"

# TODO: Write documentation for `CounterSafe`
module CounterSafe
  # Example Usage:
  # * Shared counters
  # ```
  # cs1 = CounterSafe::Shared.new
  # cs2 = CounterSafe::Shared.new
  # (1..1000).each {
  #   rand < 0.25 ? spawn cs1.inc("someKey") : spawn cs2.inc("someKey")
  # }
  #
  # sleep 1.second
  # puts cs1.value("someKey")
  # puts cs2.value("someKey") # => Should be the same as 'cs1.value("someKey")'
  # ```
  #
  # * Exclusive counters
  # ```
  # ce1 = CounterSafe::Exclusive.new
  # ce2 = CounterSafe::Exclusive.new
  # (1..1000).each {
  #   rand < 0.25 ? spawn ce1.inc("someKey") : spawn ce2.inc("someKey")
  # }
  # puts ce1.value("someKey")
  # puts ce2.value("someKey") # => Should be DIFFERENT than as 'cs1.value("someKey")'
  # ```

  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
end
