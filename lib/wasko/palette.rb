module Wasko
  # A module aimed at creating color schemes for terminals
  # Pretty straightforward, no?
  module Palette
    # Since I change my mind pretty frequently on
    # color schemes etc. Putting the actual logic in
    # a class so it's easier to extend.
    class TheOriginal
      # Takes a valid css color string and an optional
      # contrast argument. The contrast is useful to tweak
      # the output of things.
      #
      # It sets a base color `@base` and creates a color
      # palette derived from the base color using the
      # `colors!` method.
      def initialize(color_string, contrast = 0)
        @colors = {}
        @base = Wasko::Color.color_from_string(color_string)
        @base = white unless @base
        @contrast = 30 + contrast
        colors!
      end

      # Returns a `color`-instance of white
      def white
        Wasko::Color.color_from_string("white")
      end

      # Returns a `color`-instance of black
      def black
        Wasko::Color.color_from_string("black")
      end

      def ansi_colors?
        p.colors[:yellow]
      end

      # Checks the brightness of the base color and
      # returns the appropriate opposite color.
      #
      # For example black will return white, white will
      # return black.
      def opposite_color
        @base.brightness > 0.5 ? black : white
      end

      # To calculate colors that will fit our base color
      # we need to find out to brighten them, or darken
      # them
      def inverse_brightness
        @base.brightness > 0.5 ? -1 : 1
      end

      def dark_base_color?
        @base.brightness < 0.5
      end

      # Hash of the color palette
      # TODO: attr_accessible
      def colors
        @colors
      end

      # Creates a palette based on the `@base`-color. This
      # generates a color palette which has taken a good
      # look at [Solarized](http://ethanschoonover.com/solarized)
      # The plus side is you can use any base color, the
      # downside is, the colors won't be picked as well as
      # when using [Solarized](http://ethanschoonover.com/solarized) so if that's what you need, check it out.
      def colors!
        p = {}
        p[:base]       = @base
        p[:foreground] = @base.mix_with(opposite_color, @contrast + 18)
        p[:bold]       = @base.mix_with(opposite_color, @contrast + 19.5)
        p[:selection]  = @base.adjust_brightness inverse_brightness * @contrast
        p[:selected]   = p[:bold]
        p[:cursor]     = p[:foreground]

        # ANSI Colors
        p[:red]     = mix_base_with("red", 50, inverse_brightness * @contrast)
        p[:green]   = mix_base_with("green", 50, inverse_brightness * @contrast)
        p[:yellow]  = mix_base_with("yellow", 50, inverse_brightness * @contrast)
        p[:white]   = mix_base_with("white", 35, inverse_brightness * @contrast)
        p[:black]   = mix_base_with("black", 35, inverse_brightness * @contrast)
        p[:blue]    = mix_base_with("blue", 50, inverse_brightness * (@contrast))
        p[:magenta] = mix_base_with("#CA1F7B", 35, inverse_brightness * @contrast)
        p[:cyan]    = mix_base_with("#00FFFF", 50, inverse_brightness * (@contrast - 20))
        @colors = p
      end

      # Just a utility method that mixes colors, for more
      # info on this check the docs of the `color`-gem.
      def mix_base_with(color_name, mix_value = 50, brightness = 30)
        @base.mix_with(Wasko::Color.color_from_string(color_name), mix_value).adjust_brightness(brightness)
      end


      def base_color_with_tint(color_name)
        brightness = inverse_brightness * @contrast
        mix_base_with(color_name, 80, brightness)
      end
    end
  end
end
