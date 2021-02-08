module CounterSafe
  abstract class AbstractCounter
    alias InternalCounterClass = Hash(String, Int32)

    def initialize
      @mux = Mutex.new
      init_counter!
    end

    def value(key : String)
      # Retrieve the value for a single key
      @mux.lock
      get_counter!(key)
    ensure
      @mux.unlock
    end

    def inc(key : String)
      # Increment the value for a single key
      @mux.lock
      the_value = get_counter!.has_key?(key) ? get_counter!(key) + 1 : 1
      set_counter!(key, the_value)
    ensure
      @mux.unlock
      the_value
    end

    def reset!
      # Reset the value for a single key
      @mux.lock
      init_counter!
    ensure
      @mux.unlock
      get_counter!
    end

    def reset(key : String, the_value : Int32 = 0)
      # Reset the value for a single key
      @mux.lock
      set_counter!(key, the_value)
    ensure
      @mux.unlock
      the_value
    end

    ####################################################################################################################
    # Currently, trying to (de-)serialize (with to_json/from_json) an object that contains a Mutex will raise an error.
    # i.e.: include JSON::Serializable => Error: no overload matches 'Mutex#to_json' with type JSON::Builder
    # So, we'll customize the '#from_json' and '.to_json' methods...
    ####################################################################################################################

    def to_json
      # For use by simple objects
      values.to_json
    end

    def to_json(builder : JSON::Builder)
      # For use by nested objects
      builder.object do
        get_counter!.each do |k, v|
          builder.field k, v
        end
      end
      builder
    end

    def values
      # Retrieve all key-value pairs
      @mux.lock
      get_counter!
    ensure
      @mux.unlock
    end

    def self.from_json(jsonified_values : String)
      inst = self.new
      inst.reset_all(jsonified_values)
      inst
    end

    def reset_all(jsonified_values : String)
      @mux.lock
      parsed = InternalCounterClass.from_json(jsonified_values)
      set_counter!(parsed)
    ensure
      @mux.unlock
      get_counter!
    end

    ####################################################################################################################
    # NOTE: Sub-classes MUST implement the following!
    ####################################################################################################################

    protected def init_counter!
      raise "NOT IMPLEMENTED!"
    end

    protected def get_counter!
      raise "NOT IMPLEMENTED!"
    end

    protected def get_counter!(key : String)
      raise "NOT IMPLEMENTED!"
    end

    protected def set_counter!(the_value)
      raise "NOT IMPLEMENTED!"
    end

    protected def set_counter!(key : String, the_value)
      raise "NOT IMPLEMENTED!"
    end
  end
end
