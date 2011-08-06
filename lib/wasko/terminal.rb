module Wasko
  # This class will be used to strip the Applescript
  # even further away, encapsulating all the needed
  # methods to set colors and fonts of `Terminal.app`.
  #
  # Added bonus is, this paves the way to add support
  # for [iTerm2](http://code.google.com/p/iterm2/) and
  # other variants.
  class Terminal

    # Unsupported calls
    # Since Apple hasn't implemented them, no way to set
    # them, except to fall back to some GUI scripting
    #
    # If you don't like that option I've sent a pull request
    # to iTerm2 which has ansi applescript support
    def self.set_selected_text_color(color)
      # Still no dice.
    end

    def self.set_selection_color(color)

    end

    # The color wells of the prefs have these indices
    # (bright colors is +1)
    #      black   : 4
    #      red     : 6
    #      green   : 8
    #      yellow  : 10
    #      blue    : 12
    #      magenta : 14
    #      cyan    : 16
    #      white   : 18
    def self.set_ansi_black_color(color);set_color_via_gui(5, color);end
    def self.set_ansi_red_color(color);set_color_via_gui(7, color);end
    def self.set_ansi_green_color(color);set_color_via_gui(9, color);end
    def self.set_ansi_yellow_color(color);set_color_via_gui(11, color);end
    def self.set_ansi_blue_color(color);set_color_via_gui(13, color);end
    def self.set_ansi_magenta_color(color);set_color_via_gui(15, color);end
    def self.set_ansi_cyan_color(color);set_color_via_gui(17, color);end
    def self.set_ansi_white_color(color);set_color_via_gui(19, color);end

    def self.set_color_via_gui(color_index, color)
      Wasko::Applescript.run do
        <<SCRIPT
tell application "Terminal"
  activate
  tell application "System Events"
    # Open Preferences
    keystroke "," using command down
    tell process "Terminal"
      click button 2 of tool bar 1 of window 1
      # Make sure the default is selected
      set srows to every row of table 1 of scroll area 1 of group 1 of window 1
      repeat with a_row in srows
        if value of text field 1 of a_row contains "#{get_selected_theme}" then
          set selected of a_row to true
          exit repeat
        end if
      end repeat

      click color well #{color_index} of tab group 1 of group 1 of window "Settings"
      click (every button whose description is "Hex Color Picker") of tool bar 1 of window "Colors"
      set value of text field 1 of group 1 of window "Colors" to "#{color.html}"
      # Close Colors
      click button 1 of window "Colors"
      # Close prefs
      keystroke "w" using command down
    end tell
  end tell
end tell
SCRIPT
      end
    end

    def self.get_selected_theme
      @selected_theme ||=
        Wasko::Applescript.run do
        <<SCRIPT
tell application "Terminal"
  activate
  tell application "System Events"
    # Open Inspector
    tell process "Terminal"
      if window "Inspector" exists then
      else
        keystroke "I" using command down
      end if
      click radio button 2 of tab group 1 of window "Inspector"
      set selected_theme to value of text field of item 1 of (every row whose selected is true) of table 1 of scroll area 1 of tab group 1 of window "Inspector"
      click button 1 of window "Inspector"
      return selected_theme
    end tell

  end tell
end tell
SCRIPT
      end
    end
    # # Getters And Setters
    #
    # This supports the following
    #
    #  * `set_background_color "fff"`
    #  * `background_color`
    #  * `set_normal_text_color "fff"`
    #  * `normal_text_color`
    #  * `set_font_size 12`
    #  * `font_size`
    #  * `set_font_name "DejaVu Sans Mono"`
    #  * `font_name`
    #
    def self.method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^set_(.*)$/
        self.set($1.gsub(/_/, " ") => arguments.first)
      elsif method_sym.to_s =~ /^([a-z]+_[a-z]+(.*))$/
        self.get($1.gsub(/_/, " "))
      else
        super
      end
    end

    # Pretty big todo, shield this off somewhat.
    def self.respond_to?(method_sym, include_private = false)
      if method_sym.to_s =~ /^set_(.*)$/
        true
      elsif method_sym.to_s =~ /^[a-z]+_[a-z]+(.*)$/
        true
      else
        super
      end
    end

    protected

    def self.set(conditions = {})
      Wasko::Applescript.run do
        self.set_script(conditions.keys.first, conditions.values.first)
      end
    end

    def self.get(object)
      Wasko::Applescript.run do
        self.get_script(object)
      end
    end

    # ## Utility methods
    #
    # Setter
    #
    #      Wasko::Terminal.set_script("background color", "red")
    #
    def self.set_script(object, value)
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
    #      Wasko::Terminal.get_script("background color")
    #
    def self.get_script(object)
      <<SCRIPT
tell application "Terminal"
  get #{object} of selected tab of first window
end tell
SCRIPT
    end

  end
end
