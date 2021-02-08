require "../spectator_helper"

Spectator.describe CounterSafe::Exclusive do
  # Unfortunately, mutex's don't seem to work with to_/from_json, so we'll use a 'reset' method.
  # i.e.: include JSON::Serializable => Error: no overload matches 'Mutex#to_json' with type JSON::Builder
  # describe "to_json and from_json" do
  #   it "converts to and from json without raising" do
  #     expect{
  #       safe_counter_cloned = safe_counter.class.from_json(safe_counter.to_json)
  #     }.no_to raise_error
  #   end
  # end
  it "example usage" do
    cs1 = CounterSafe::Exclusive.new
    cs2 = CounterSafe::Exclusive.new
    (1..1000).each {
      rand < 0.25 ? spawn cs1.inc("someKey") : spawn cs2.inc("someKey")
    }

    sleep 1.second
    value1 = cs1.value("someKey")
    value2 = cs2.value("someKey")
    expect(value1).not_to eq(value2)
  end

  describe "#initialize" do
    it "does not raise" do
      expect { CounterSafe::Exclusive.new }.not_to raise_error
    end
  end

  describe "#value" do
    let(counter) { CounterSafe::Exclusive.new }
    let(key) { Faker::Name.name }
    it "start off at zero" do
      value_before = counter.value(key)

      expect(value_before).to eq(0)
    end
  end

  describe "#inc" do
    let(counter) { CounterSafe::Exclusive.new }
    let(key) { Faker::Name.name }
    it "increments the counter" do
      value_before = counter.value(key).clone
      counter.inc(key)
      value_after = counter.value(key).clone

      expect(value_after).to eq(value_before + 1)
    end

    context "when called multiple times" do
      let(qty_times) { rand(10) }
      it "increments the counter multiple times" do
        value_before = counter.value(key).clone
        qty_times.times do
          counter.inc(key)
        end
        value_after = counter.value(key).clone

        expect(value_after).to eq(value_before + qty_times)
      end
    end
  end

  describe "#reset" do
    let(counter) { CounterSafe::Exclusive.new }
    let(key) { Faker::Name.name }
    context "when called multiple times" do
      let(qty_times) { rand(10) }
      context "and then reset to a value" do
        let(a_value) { qty_times - rand(10) }
        it "increments the counter multiple times" do
          value_before = counter.value(key).clone
          expect(value_before).to eq(0)

          qty_times.times do
            counter.inc(key)
          end
          counter.reset(key, a_value)
          value_after = counter.value(key).clone

          expect(value_after).to eq(a_value)
        end
      end
    end
  end

  describe "when we have multiple counters" do
    let(counter1) { CounterSafe::Exclusive.new }
    let(counter2) { CounterSafe::Exclusive.new }
    let(key) { Faker::Name.name }
    let(qty_times) { rand(10) }

    before_each do
      counter1.reset!
      counter2.reset!
    end

    it "they DO NOT shares the counts for same key" do
      expected_counter1 = 0
      expected_counter2 = 0
      value1_before = counter1.value(key).clone
      value2_before = counter2.value(key).clone
      expect(value1_before).to eq(expected_counter1)
      expect(value2_before).to eq(expected_counter2)

      counter1.inc(key)
      expected_counter1 += 1

      counter2.inc(key)
      expected_counter2 += 1

      counter1.inc(key)
      expected_counter1 += 1

      counter2.inc(key)
      expected_counter2 += 1

      counter1.inc(key)
      expected_counter1 += 1

      value1_after = counter1.value(key).clone
      value2_after = counter2.value(key).clone

      expect(value1_after).to be > (value1_before)
      expect(value2_after).to be > (value2_before)

      expect(value1_after).to eq(expected_counter1)
      expect(value2_after).to eq(expected_counter2)
    end
  end
end
