require 'helper'

class TestWaskoColor < Test::Unit::TestCase

  should "convert from applescript" do
    assert_equal ::Color::RGB.from_html("#fff"), ::Color::RGB.from_applescript("{65535,65535,65535}")
  end

  should "convert to applescript" do
    assert_equal "{65535, 65535, 65535}", ::Color::RGB.from_html("#fff").to_applescript
  end

  should "convert #fff to Color" do
    assert_equal ::Color::RGB.from_html("#fff"), Wasko::Color.color_from_string("#fff")
  end

  should "convert #cccccc to Color" do
    assert_equal ::Color::RGB.from_html("#cccccc"), Wasko::Color.color_from_string("#cccccc")
  end

  should "convert aliceblue to Color" do
    assert_equal ::Color::RGB.from_html("#f0f8ff"), Wasko::Color.color_from_string("aliceblue")
  end

  should "handle upcased css names to Color" do
    assert_equal ::Color::RGB.from_html("#ff0000"), Wasko::Color.color_from_string("RED")
  end

  should "gracefully handle bogus input names" do
    assert_nil Wasko::Color.color_from_string("poppycock")
  end
end
