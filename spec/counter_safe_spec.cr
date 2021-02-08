require "./spectator_helper"

Spectator.describe CounterSafe do
  describe "VERSION" do
    it "is a String" do
      expect(CounterSafe::VERSION).to be_a(String)
    end
  end
end
