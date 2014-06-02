require 'helper'

describe Wasko do

  it "set background color to tint" do
    ata = mock()
    ata.expects(:startup_background_color).returns("{0,0,0}")
    ata.expects(:set_background_color).with("{16962, 0, 0}").returns(nil)
    Wasko.stubs(:advanced_typing_apparatus).returns(ata)
    Wasko.set_background_color("red")
  end

  describe "setting palette" do
    before do
      @color = Wasko::Color.color_from_string("white")
      palette = mock()
      palette.expects(:colors).returns({:base => @color, :foreground => @color, :bold => @color, :cursor => @color, :selected => @color, :selection => @color}).at_least_once
      Wasko::Palette::Original.expects(:new).with("white").returns(palette)

    end

    it "draw a palette" do
      Wasko.expects(:set_background_color).with(@color.html)
      Wasko.expects(:set_foreground_color).with(@color.html)
      Wasko.expects(:set_bold_color).with(@color.html)
      Wasko.expects(:set_cursor_color).with(@color.html)
      Wasko.set_palette("white")
    end

  end

  it "set palette" do

  end

  it "get font size" do
    ata = mock()
    ata.expects(:font_size).returns("14")
    Wasko.expects(:advanced_typing_apparatus).returns(ata)
    assert_equal Wasko.font_size, "14"
  end

  it "set font size" do
    ata = mock()
    ata.expects(:set_font_size).with("14")
    Wasko.expects(:advanced_typing_apparatus).returns(ata)
    Wasko.set_font_size "14"
  end

  it "get font name" do
    ata = mock()
    ata.expects(:font_name).returns("SomeFont")
    Wasko.expects(:advanced_typing_apparatus).returns(ata)
    assert_equal Wasko.font_name, "SomeFont"
  end

  it "set font name" do
    ata = mock()
    ata.expects(:set_font_name).with("SomeFont")
    Wasko.expects(:advanced_typing_apparatus).returns(ata)
    Wasko.set_font_name("SomeFont")
  end

  it "get font" do
    ata = mock()
    ata.expects(:font_name).returns("SomeFont")
    ata.expects(:font_size).returns("14")
    Wasko.expects(:advanced_typing_apparatus).returns(ata).at_least_once
    assert_equal Wasko.font, "SomeFont, 14"
  end

  it "set font" do
    ata = mock()
    ata.expects(:set_font_name).with("SomeFont")
    ata.expects(:set_font_size).with(14)
    Wasko.expects(:advanced_typing_apparatus).returns(ata).at_least_once
    Wasko.set_font(14, "SomeFont")
  end

  # Just so we can dynamically create the color tests.
  def method_to_expect(method)
    case method
    when "foreground_color"
      "normal_text_color"
    when "bold_color"
      "bold_text_color"
    else
      method
    end
  end

  # Test all getter/setter colors
  describe "getting/setting regular colors" do
    %w(cursor_color foreground_color bold_color).each do |method|

      before do
        @color = Wasko::Color.color_from_string("white")
      end

      it "get the #{method} of the advanced typing apparatus" do
        ata = mock()
        ata.expects(method_to_expect(method).to_sym).returns(@color.to_applescript)
        Wasko.expects(:advanced_typing_apparatus).returns(ata)
        assert_equal @color.html, Wasko.send(method)
      end

      it "set the #{method} of the advanced typing apparatus" do

        ata = mock()
        ata.expects("set_#{method_to_expect(method)}".to_sym).with(@color.to_applescript)
        Wasko.expects(:advanced_typing_apparatus).returns(ata)
        Wasko.send("set_#{method}", @color.html)
      end
    end
  end
end
