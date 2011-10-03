require "wasko/terminal/ansi_colors"
module Wasko
  # This class will be used to strip the Applescript
  # even further away, encapsulating all the needed
  # methods to set colors and fonts of `Terminal.app`.
  #
  # Added bonus is, this paves the way to add support
  # for [iTerm2](http://code.google.com/p/iterm2/) and
  # other variants.
  class Terminal
    extend AnsiColors
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

    def self.set_selected_theme(theme_name)
      output = Wasko::Applescript.run do
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
	    set srows to every row of table 1 of scroll area 1 of tab group 1 of window "Inspector"
      set theme_found to false
			repeat with a_row in srows
        if value of text field of a_row contains "#{theme_name}" then
          set theme_found to true
          set selected of a_row to true
        end if
      end repeat

      if theme_found then
        # Theme selected
        # Close inspector window
        keystroke "w" using command down
      else
        keystroke "w" using command down
        #{add_theme_script(theme_name)}
        # Cleanup
        keystroke "w" using command down
        return "NOT_FOUND"
      end if
    end tell
  end tell
end tell
SCRIPT
      end

      # Doing this in Ruby because Applescript is that much
      # teh suck combined.
      set_selected_theme(theme_name) if output == "NOT_FOUND"
    end

    # This string will add a new theme to the Terminal's preferences
    # if evaluated by Applescript
    def self.add_theme_script(theme_name)
        <<SCRIPT
tell application "Terminal"
	activate
	tell application "System Events"
		# Open Preferences
		keystroke "," using command down
		tell process "Terminal"
			# Create the wasko theme placeholder
			click button 2 of tool bar 1 of window 1
			click (every button whose description is "Add") of group 1 of window 1
			keystroke "#{theme_name}"
			key code 36 # hits return
		end tell
	end tell
end tell
SCRIPT
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
