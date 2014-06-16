module Wasko
  # A module aimed at creating color schemes for terminals
  # Pretty straightforward, no?
  module Palette
    class Base
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

    end
  end
end
