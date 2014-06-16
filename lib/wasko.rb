# coding: utf-8

begin
  require 'rubygems'
rescue LoadError
end

require "color/palette/monocontrast"
require "yaml"

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

# [Applescript: Small wrapper for running applescript](applescript.html)
require "wasko/applescript"
# [Terminal: Support for Terminal.app](terminal.html)
require "wasko/terminal"
# [iTerm: Support for iTerm.app](iterm.html)
require "wasko/iterm"
# [Color: Small color utilities](color.html)
require "wasko/color"
# [Palette: Generates a color scheme](palette.html)
require "wasko/palette"
require "wasko/palettes/original"
# [Configuration: Loading and saving themes](configuration.html)
require "wasko/configuration"

module Wasko
  class << self

    # Currently this only returns Apple's `Terminal.app`,
    # in the future this could be used to support other
    # Terminals as well.
    def advanced_typing_apparatus
      return Wasko::Terminal if current_application =~ /Terminal.app/
      return Wasko::Iterm if current_application =~ /iTerm.app/
      # Fall back to Terminal for CI
      return Wasko::Terminal
    end

    # Gets the current active application
    def current_application
      Wasko::Applescript.run do
        "get name of (info for (path to frontmost application))"
      end
    end

    # ## Set/Get fonts and colors
    #
    # These all call the `advanced_typing_apparatus` and
    # do exactly what they say on the tin.
    #
    def background_color
      ::Color::RGB.from_applescript(advanced_typing_apparatus.background_color).html
    end

    # Takes a color and mixes it with the original background color, so
    # the newly generated color should look kinda like the other.
    #
    #       color - A string with a css or hex color
    #
    # Sets the background color
    def set_background_color(color)
      color = Wasko::Color.color_from_string(color)
      advanced_typing_apparatus.set_background_color(color.to_applescript)
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

    def set_selected_text_color(color)
      advanced_typing_apparatus.set_selected_text_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_selection_color(color)
      advanced_typing_apparatus.set_selection_color(Wasko::Color.color_from_string(color).to_applescript)
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

    # ### Ansi Colors

    def set_ansi_black_color(color)
      advanced_typing_apparatus.set_ansi_black_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_ansi_red_color(color)
      advanced_typing_apparatus.set_ansi_red_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_ansi_green_color(color)
      advanced_typing_apparatus.set_ansi_green_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_ansi_yellow_color(color)
      advanced_typing_apparatus.set_ansi_yellow_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_ansi_blue_color(color)
      advanced_typing_apparatus.set_ansi_blue_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_ansi_magenta_color(color)
      advanced_typing_apparatus.set_ansi_magenta_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_ansi_cyan_color(color)
      advanced_typing_apparatus.set_ansi_cyan_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def set_ansi_white_color(color)
      advanced_typing_apparatus.set_ansi_white_color(Wasko::Color.color_from_string(color).to_applescript)
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
      p = Wasko::Palette::Original.new(color_string)

      set_background_color p.colors[:base].html
      set_foreground_color p.colors[:foreground].html
      set_bold_color p.colors[:bold].html
      set_cursor_color p.colors[:cursor].html
      set_selected_text_color p.colors[:selected].html
      set_selection_color p.colors[:selection].html
    end

  end
end
