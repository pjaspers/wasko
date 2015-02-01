module Wasko
  module Palette
    class Plain < Base

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

    end
  end
end
