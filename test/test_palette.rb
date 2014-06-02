require 'helper'

describe Wasko::Palette::Original do
  it "is" do
    assert true
  end
end
describe Wasko::Palette do

  %w(white black blue green red 001e26 pink).each do |color_string|
    describe "creating a palette for #{color_string}" do

      before do
        @base_color = Wasko::Color.color_from_string("white")
        @palette = Wasko::Palette::Original.new("white")
      end

      it "have a foreground color with a high contrast" do
        assert 0.5 < (@palette.colors[:foreground].brightness - @base_color.brightness).abs
      end

      it "set its base color as the background color" do
        assert_equal @base_color, @palette.colors[:base]
      end
    end
  end

  it "generate all colors in its hash" do
    palette = Wasko::Palette::Original.new("white")
    colors = %w(base foreground bold selection selected cursor red green yellow white black blue magenta cyan)

    assert_equal [],palette.colors.keys - colors.map(&:to_sym)
  end

  it "generate a white colorscheme on faulty input" do
    palette = Wasko::Palette::Original.new("fokdajong")
    palette.colors[:base] = palette.white
  end

end
