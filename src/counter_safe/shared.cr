require "./abstract_counter.cr"

module CounterSafe
  class Shared < AbstractCounter
    @@v = InternalCounterClass.new(0)

    protected def init_counter!
      @@v = InternalCounterClass.new(0)
    end

    protected def get_counter!
      @@v
    end

    protected def get_counter!(key : String)
      @@v[key]
    end

    protected def set_counter!(the_value)
      @@v = the_value
    end

    protected def set_counter!(key : String, the_value)
      @@v[key] = the_value
    end
  end
end
