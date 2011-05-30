require "color/palette/monocontrast"
require "yaml"
# [Applescript: Small wrapper for running applescript](applescript.html)
require "wasko/applescript"
# [Terminal: Support for Terminal.app](terminal.html)
require "wasko/terminal"
# [Color: Small color utilities](color.html)
require "wasko/color"
# [Palette: Generates a color scheme](palette.html)
require "wasko/palette"
# [Configuration: Loading and saving themes](configuration.html)
require "wasko/configuration"

module Wasko
  class << self

    # Currently this only returns Apple's `Terminal.app`,
    # in the future this could be used to support other
    # Terminals as well.
    def advanced_typing_apparatus
      Wasko::Terminal
    end

    # ## Set/Get fonts and colors
    #
    # These all call the `advanced_typing_apparatus` and
    # do exactly what they say on the tin.
    #
    def background_color
      ::Color::RGB.from_applescript(advanced_typing_apparatus.background_color).html
    end

    def set_background_color(color)
      advanced_typing_apparatus.set_background_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def foreground_color
      ::Color::RGB.from_applescript(advanced_typing_apparatus.normal_text_color).html
    end

    def set_foreground_color(color)
      advanced_typing_apparatus.set_normal_text_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def bold_color
      ::Color::RGB.from_applescript(advanced_typing_apparatus.bold_text_color).html
    end

    def set_bold_color(color)
      advanced_typing_apparatus.set_bold_text_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def cursor_color
      ::Color::RGB.from_applescript(advanced_typing_apparatus.cursor_color).html
    end

    def set_cursor_color(color)
      advanced_typing_apparatus.set_cursor_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def font_name
      advanced_typing_apparatus.font_name
    end

    def set_font_name(name)
      advanced_typing_apparatus.set_font_name name
    end

    def font_size
      advanced_typing_apparatus.font_size
    end

    def set_font_size(size)
       advanced_typing_apparatus.set_font_size size
    end

    def font
      "#{advanced_typing_apparatus.font_name}, #{advanced_typing_apparatus.font_size}"
    end

    def set_font(font_size = 14, name = nil)
      name = font_name if name.empty?
      set_font_size font_size
      set_font_name name
    end

    # ## Palette
    #
    # Returns a string representation of the current settings
    def palette
      [
       "Background: #{background_color}",
       "Foreground: #{foreground_color}",
       "Bold Text : #{bold_color}",
       "Cursor    : #{cursor_color}",
       "Font      : #{font}"
      ].join("\n")
    end

    # Try to set a sensible palette from a base color
    def set_palette(color_string)
      p = Wasko::Palette::TheOriginal.new(color_string)

      set_background_color p.colors[:base].html
      set_foreground_color p.colors[:foreground].html
      set_bold_color p.colors[:bold].html
      set_cursor_color p.colors[:cursor].html
    end

  end
end
