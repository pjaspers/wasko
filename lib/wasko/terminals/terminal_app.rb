module Wasko
  class TerminalApp < Terminal
    # # Getters And Setters
    #

    def cursor_color
      get_script("cursor color")
    end

    def set_cursor_color(color)
      set_script("cursor color", color)
    end

    def background_color
      get_script("background color")
    end

    def set_background_color(color)
      set_script("background color", color)
    end

    def normal_text_color
      get_script("normal text color")
    end

    def set_normal_text_color(color)
      set_script("normal text color", color)
    end

    def font_size
      get_script("font size")
    end

    def set_font_size(size)
      set_script("font size", size)
    end

    def font_name
      get_script("font size")
    end

    def set_font_name(name)
      set_script("font name", name)
    end

    # Unsupported calls
    # Since Apple hasn't implemented them, no way to set
    # them, except to fall back to brittle GUI scripting
    # and I'm not really looking forward to doing that.
    def self.set_selected_text_color(color);end
    def self.set_selection_color(color);end
    def self.set_ansi_black_color(color);end
    def self.set_ansi_red_color(color);end
    def self.set_ansi_green_color(color);end
    def self.set_ansi_yellow_color(color);end
    def self.set_ansi_blue_color(color);end
    def self.set_ansi_magenta_color(color);end
    def self.set_ansi_cyan_color(color);end
    def self.set_ansi_white_color(color);end

    protected

    # ## Utility methods
    #
    # Setter
    #
    #      Wasko::TerminalApp.new.set_script("background color", "red")
    #
    def set_script(object, value)
      unless value =~ /^(\{|\[|\()/
        value = "\"#{value}\""
      end
      <<SCRIPT
tell application "Terminal"
  set #{object} of selected tab of first window to #{value}
end tell
SCRIPT
    end

    # Getter
    #
    #      Wasko::TerminalApp.new.get_script("background color")
    #
    def get_script(object)
      <<SCRIPT
tell application "Terminal"
  get #{object} of selected tab of first window
end tell
SCRIPT
    end
  end
end
