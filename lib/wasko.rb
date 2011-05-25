require "color/palette/monocontrast"
require "yaml"
require "wasko/applescript"
require "wasko/terminal"

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
      advanced_typing_apparatus.background_color
    end

    def set_background_color(color)
      advanced_typing_apparatus.set_background_color(color)
    end

    def foreground_color
      advanced_typing_apparatus.normal_text_color
    end

    def set_foreground_color(color)
      advanced_typing_apparatus.set_normal_text_color(color)
    end

    def cursor_color
      advanced_typing_apparatus.cursor_color
    end

    def set_cursor_color(color)
      advanced_typing_apparatus.set_cursor_color color
    end

    def font
      "#{advanced_typing_apparatus.font_name}, #{advanced_typing_apparatus.font_size}"
    end

    def set_font(font_name, font_size = 14)
      advanced_typing_apparatus.set_font_name font_name
      advanced_typing_apparatus.set_font_size font_size
    end

    # ## Palette
    #
    # Trying to create a sensible palette that doesn't suck
    def palette_from_color(hex_color)
      palette = ::Color::Palette::MonoContrast.new(::Color::RGB.from_html(hex_color))

      palette_colors = {
        :background => color_to_rgb(palette.background[2]),
        :foreground => color_to_rgb(palette.foreground[2])
      }
      draw_rgb_color palette_colors
    end

    # ## Named Colors
    #
    # Applescript has a notion of named colors, these can be
    # used, but in the future I'm looking more to create
    # your own schemes.
    def colors
      %w(blue yellow white red orange green black brown cyan purple magenta)
    end

    # ## RGB Colors
    #
    # Applescript uses `short int` to make the RGB like this:
    #
    #      {65535, 65535, 65535, 65535}
    #      { red, green, blue, opacity}
    #
    # The `color`-gem doesn't do this, so transforming the
    # values to something `Applescript` wouldn't mind'
    def color_to_rgb(color, opacity=100)
      rgb = [color.red.to_i * 257, color.green.to_i * 257, color.blue.to_i * 257, opacity * 65535/100].join(", ")
      "{#{rgb}}"
    end

    # Examples
    #
    #      Wasko.draw_css_color "ffffff"
    #       => Sets background color to white
    #
    #      Wasko.draw_css_color :background => "fff", :foreground => "ccc"
    #       => Sets back-and foreground color
    def draw_css_color(color_hash)
      unless Hash === color_hash
        color_hash = {:background => color_hash}
      end
      rgb_hash = color_hash.inject({}) do |h, (k, v)|
        h[k] = color_to_rgb(Color::RGB.from_html(v)) rescue "ffffff"
        h
      end
      draw_rgb_color rgb_hash
    end

    # Examples
    #
    #     Wasko.draw_rgb_color(:background => {65535, 65535,65535, 655535})
    #     Wasko.draw_rgb_color(:foreground => {65535, 65535,65535, 655535})
    def draw_rgb_color(color_hash)
      if color_hash[:background]
        set_background_color color_hash[:background]
      end

      if color_hash[:foreground]
        set_foreground_color color_hash[:foreground]
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
