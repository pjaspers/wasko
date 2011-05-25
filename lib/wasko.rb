require "color/palette/monocontrast"
require "yaml"
# [Applescript](applescript.html)
require "wasko/applescript"
# [Terminal](terminal.html)
require "wasko/terminal"
# [Color](color.html)
require "wasko/color"

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
      advanced_typing_apparatus.set_bold_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def cursor_color
      ::Color::RGB.from_applescript(advanced_typing_apparatus.cursor_color).html
    end

    def set_cursor_color(color)
      advanced_typing_apparatus.set_cursor_color(Wasko::Color.color_from_string(color).to_applescript)
    end

    def font
      "#{advanced_typing_apparatus.font_name}, #{advanced_typing_apparatus.font_size}"
    end

    def set_font(font_name, font_size = 14)
      puts font_name
      advanced_typing_apparatus.set_font_name font_name
      advanced_typing_apparatus.set_font_size font_size
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
      if color = Wasko::Color.color_from_string(color_string)
        palette = ::Color::Palette::MonoContrast.new(color)

        set_background_color palette.background[-3].html
        set_foreground_color palette.foreground[1].html
        set_bold_text_color palette.background[-1].html
        set_cursor_color palette.foreground[-3].html
      end
    end

    # # Configuration

    def config_file_exists?

    end

    def config
      {} unless File.exists?(config_file)
      if Hash === YAML::load(File.open(config_file))
        YAML::load(File.open(config_file))[:wasko]
      else
        {}
      end
    end

    def config_file
      File.join(ENV['HOME'],'.wasko')
    end

    def saved_colors
      "" unless config && config[:colors]
      config[:colors].keys
    end

    # ## Loading and saving colors
    def load_color_from_config(name)
      return unless config && config[:colors] && config[:colors][name]
      draw_rgb_color config[:colors][name]
    end

    def save_color_to_config(rgb_values, name)
      colors = config[:colors] rescue {}
      colors[name] = rgb_values
      File.open(config_file, 'w') do |out|
        out.write({:wasko => {:colors => colors}}.to_yaml)
      end
    end
  end
end
