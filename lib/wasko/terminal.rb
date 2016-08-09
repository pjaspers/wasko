module Wasko
  # This class will be used to strip the Applescript
  # even further away, encapsulating all the needed
  # methods to set colors and fonts of `Terminal.app`.
  #
  # Added bonus is, this paves the way to add support
  # for [iTerm2](http://code.google.com/p/iterm2/) and
  # other variants.
  class Terminal

    def background_color;end
    def set_background_color(color);end
    def normal_text_color;end
    def set_normal_text_color(color);end
    def font_size;end
    def set_font_size(size);end
    def font_name;end
    def set_font_name(name);end

    def set_selected_text_color(color);end
    def set_selection_color(color);end
    def set_ansi_black_color(color);end
    def set_ansi_red_color(color);end
    def set_ansi_green_color(color);end
    def set_ansi_yellow_color(color);end
    def set_ansi_blue_color(color);end
    def set_ansi_magenta_color(color);end
    def set_ansi_cyan_color(color);end
    def set_ansi_white_color(color);end
  end
end
