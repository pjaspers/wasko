require 'helper'

class TestWaskoColor < Test::Unit::TestCase
  should "convert #fff to Color" do
    assert_equal ::Color::RGB.from_html("#fff"), Wasko::Color.color_from_string("#fff")
  end

  should "convert #cccccc to Color" do
    assert_equal ::Color::RGB.from_html("#cccccc"), Wasko::Color.color_from_string("#cccccc")
  end

  should "convert aliceblue to Color" do
    assert_equal ::Color::RGB.from_html("#f0f8ff"), Wasko::Color.color_from_string("aliceblue")
  end
end
