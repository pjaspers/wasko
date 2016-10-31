require "color"

class Color::RGB

  class << self
    # Creates a `color` from an `Applescript` string,
    # `Applescript` uses `short int` to make the RGB,
    # `65535` is the maximum.
    #
    # Example:
    #
    #      Color::RGB.from_applescript "65535,65535,65535"
    #        => <RGB [#ffffff]>
    #
    def from_applescript(applescript_string)
      applescript_string.gsub!(/\{|\}/, "")
      rgb = applescript_string.strip.split(",")
      colors = rgb.map do |value|
        value.to_i / 257
      end
      Color::RGB.new(*colors)
    end
  end

  # Converts an instance of `Color` to an `Applescript`
  # string color format.
  def to_applescript
    rgb = [self.red.to_i * 257, self.green.to_i * 257, self.blue.to_i * 257].join(", ")
    "{#{rgb}}"
  end
end

module Wasko
  # This class will be used to handle (aptly named, it is)
  # all things concerning Color. Internally we'll be mostly
  # using the [color gem](http://rubydoc.info/gems/color/1.4.1/frames)
  class Color

    # Tries to get a `Color` from a string, will return `false`
    # if it fails to do so, if it does recognize a color converts it
    # to a format that `Applescript` will support.
    #
    # At the moment support all named css-colors (like `red`, `aliceblue`, etc.)
    # and all hex-colors.
    def self.color_from_string(color_string)
      ::Color::RGB.by_css(color_string)
    rescue ArgumentError
      nil
    end
  end
end
