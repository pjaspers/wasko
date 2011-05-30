require 'helper'

class TestWaskoPalette < Test::Unit::TestCase

  %w(white black blue green red 001e26 pink).each do |color_string|
    context "creating a palette for #{color_string}" do

      setup do
        @base_color = Wasko::Color.color_from_string("white")
        @palette = Wasko::Palette::TheOriginal.new("white")
      end

      should "have a foreground color with a high contrast" do
        assert 0.5 < (@palette.colors[:foreground].brightness - @base_color.brightness).abs
      end

      should "set its base color as the background color" do
        assert_equal @base_color, @palette.colors[:base]
      end
    end
  end

  should "generate all colors in its hash" do
    palette = Wasko::Palette::TheOriginal.new("white")
    colors = %w(base foreground bold selection selected cursor red green yellow white black blue magenta cyan)

    assert_equal [],palette.colors.keys - colors.map(&:to_sym)
  end

  should "generate a white colorscheme on faulty input" do
    palette = Wasko::Palette::TheOriginal.new("fokdajong")
    palette.colors[:base] = palette.white
  end

end

