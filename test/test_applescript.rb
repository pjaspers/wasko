require 'helper'

describe Wasko::Applescript do
  it "run an applescript and catch its return value" do
    value = Wasko::Applescript.run {"set ten_and_ten to 10 + 10"}
    assert_equal 20.to_s, value
  end
end
