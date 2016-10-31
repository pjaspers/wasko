module Wasko
  # A base class that defines most of the methods and expects its
  # subclasses to implement the `get_script` and `set_script` methods.
  #
  # This allows for a plugin-style setup. At the moment the following
  # are implemented:
  #
  #      - Terminal.app
  #      - iTerm.app < v3
  #      - iTerm.app v3
  #
  class Terminal
    # Define the methods that will transfrom an applescript noun to a ruby method
    # e.g.
    #
    #      normal text color => normal_text_color
    #
    def self.getter_for_applescript_noun(noun)
      noun.split(" ").join("_")
    end

    def self.setter_for_applescript_noun(noun)
      "set_%s" % noun.split(" ").join("_")
    end

    # ## Colors
    #
    # A list of all available color nouns, these are all the nouns that deal with a color.
    #
    COLOR_NOUNS = [
      "cursor color", "background color", "normal text color",
      "selected text color", "selection color",
      "ansi black color", "ansi red color", "ansi green color",
      "ansi yellow color", "ansi blue color", "ansi magenta color",
      "ansi cyan color", "ansi white color"
    ]
    # This will generate these methods:
    #
    # def cursor_color; end              def set_cursor_color; end
    # def background_color;end           def set_background_color(color);end
    # def normal_text_color;end          def set_normal_text_color(color);end
    # def selected_text_color(color);end def set_selected_text_color(color);end
    # def selection_color(color); end    def set_selection_color(color);end
    # def ansi_black_color;end           def set_ansi_black_color(color);end
    # def ansi_red_color;end             def set_ansi_red_color(color);end
    # def ansi_green_color;end           def set_ansi_green_color(color);end
    # def ansi_yellow_color;end          def set_ansi_yellow_color(color);end
    # def ansi_blue_color;end            def set_ansi_blue_color(color);end
    # def ansi_magenta_color;end         def set_ansi_magenta_color(color);end
    # def ansi_cyan_color;end            def set_ansi_cyan_color(color);end
    # def ansi_white_color;end           def set_ansi_white_color(color);end
    #
    # Dynamically defines the getter and setter method for the noun.
    def self.apply_colour_noun(noun)
      define_method getter_for_applescript_noun(noun) do
        get_script(noun)
      end

      define_method setter_for_applescript_noun(noun) do |color|
        color = ensure_color(color)
        set_script(noun, color)
      end
    end

    COLOR_NOUNS.each do |applescript_noun|
      apply_colour_noun(applescript_noun)
    end

    # ## Fonts
    #
    FONT_NOUNS = [
      "font size", "font name"
    ]
    # This will generate these methods:
    #
    #     def font_size;end    def set_font_size(size);end
    #     def font_name;end    def set_font_name(name);end
    #
    # Dynamically defines the getter and setter method for the noun.
    #
    FONT_NOUNS.each do |applescript_noun|
      define_method getter_for_applescript_noun(applescript_noun) do
        get_script(applescript_noun)
      end

      define_method setter_for_applescript_noun(applescript_noun) do |value|
        set_script(applescript_noun, value)
      end
    end

    # Helper method to ensure an applescript color is returned
    def ensure_color(color)
      if ::Color === color
        color.to_applescript
      else
        if color = Color.color_from_string(color)
          color.to_applescript
        else

        end
      end
    end

    def get_script(applescript_noun)
      fail "Implement me"
    end

    def set_script(applescript_noun, value)
      fail "Implement me"
    end
  end
end
