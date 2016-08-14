require "helper"

describe Wasko::Terminal do

  describe ".getter_for_applescript_noun" do
    it "transforms to a valid ruby method" do
      result = Wasko::Terminal.getter_for_applescript_noun("background color")
      assert_equal "background_color", result
    end
  end

  describe ".setter_for_applescript_noun" do
    it "transforms to a valid ruby method" do
      result = Wasko::Terminal.setter_for_applescript_noun("background color")
      assert_equal "set_background_color", result
    end
  end

  describe "#ensure_color" do
    let(:subject) { Wasko::Terminal.new }

    it "returns applescript version of a `Color`" do
      color = ::Color::RGB.new(0,255,0)
      assert_equal "{0, 65535, 0}", subject.ensure_color(color)
    end

    it "returns applescript version of a css color" do
      assert_equal "{0, 32896, 0}", subject.ensure_color("green")
    end
  end

  describe "defining dynamic methods" do
    before do
      @terminal = Wasko::Terminal.new
    end

    (Terminal::COLOR_NOUNS + Terminal::FONT_NOUNS).each do |method|
      it "support getter #{method}" do
        assert_respond_to @terminal, Wasko::Terminal.getter_for_applescript_noun(method)
      end

      it "support setter set_#{method}" do
        assert_respond_to @terminal, Wasko::Terminal.setter_for_applescript_noun(method)
      end
    end
  end
end
