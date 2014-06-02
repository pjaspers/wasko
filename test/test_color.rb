require 'helper'

describe Wasko::Color do

  it "convert from applescript" do
    assert_equal ::Color::RGB.from_html("#fff"), ::Color::RGB.from_applescript("{65535,65535,65535}")
  end

  it "convert to applescript" do
    assert_equal "{65535, 65535, 65535}", ::Color::RGB.from_html("#fff").to_applescript
  end

  it "convert #fff to Color" do
    assert_equal ::Color::RGB.from_html("#fff"), Wasko::Color.color_from_string("#fff")
  end

  it "convert #cccccc to Color" do
    assert_equal ::Color::RGB.from_html("#cccccc"), Wasko::Color.color_from_string("#cccccc")
  end

  it "convert aliceblue to Color" do
    assert_equal ::Color::RGB.from_html("#f0f8ff"), Wasko::Color.color_from_string("aliceblue")
  end

  it "handle upcased css names to Color" do
    assert_equal ::Color::RGB.from_html("#ff0000"), Wasko::Color.color_from_string("RED")
  end

  it "gracefully handle bogus input names" do
    assert_nil Wasko::Color.color_from_string("poppycock")
  end
end
