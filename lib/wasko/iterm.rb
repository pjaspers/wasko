module Wasko
  # Adds support for [iTerm2](http://code.google.com/p/iterm2/)
  class Iterm
    def normal_text_color
      foreground_color
    end

    def font_name
      'Not supported'
    end

    def font_size
      'Not supported'
    end

    def bold_text_color
      bold_color
    end

    # Terminal.app uses a slightly different terminology
    def set_normal_text_color(color)
      set_foreground_color color
    end

    def set_bold_text_color(color)
      set_bold_color color
    end

    # iTerm doesn't have a way to get back the original color,
    # falling back to black for now.
    #
    # Returns an applescript color
    def startup_background_color
      "{0,0,0}"
    end

    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^set_(.*)$/
        set($1.gsub(/_/, " ") => arguments.first)
      elsif method_sym.to_s =~ /^([a-z]+_[a-z]+(.*))$/
        get($1.gsub(/_/, " "))
      else
        super
      end
    end

    # Pretty big todo, shield this off somewhat.
    def respond_to?(method_sym, include_private = false)
      if method_sym.to_s =~ /^set_(.*)$/
        true
      elsif method_sym.to_s =~ /^[a-z]+_[a-z]+(.*)$/
        true
      else
        super
      end
    end

    protected

    def set(conditions = {})
      Wasko::Applescript.run do
        set_script(conditions.keys.first, conditions.values.first)
      end
    end

    def get(object)
      Wasko::Applescript.run do
        get_script(object)
      end
    end

    # ## Utility methods
    #
    # Setter
    #
    #      Wasko::Terminal.set_script("background color", "red")
    #
    def set_script(object, value)
      unless value =~ /^(\{|\[|\()/
        value = "\"#{value}\""
      end

      new_script = <<SCRIPT
tell application "iTerm"
    tell current session of current window
        set #{object} to #{value}
    end tell
end tell
SCRIPT
      old_script = <<SCRIPT
tell application "iTerm"
      set #{object} of current session of current terminal to #{value}
end tell
SCRIPT
      ding(new_script, old_script)
    end

    # Getter
    #
    #      Wasko::Terminal.get_script("background color")
    #
    def get_script(object)
      new_script = <<SCRIPT
tell application "iTerm"
    tell current session of current window
        get #{object}
    end tell
end tell
SCRIPT
      old_script = <<SCRIPT
tell application "iTerm"
  get #{object} of current session of current terminal
end tell
SCRIPT
      ding(new_script, old_script)
    end

    def ding(new_script, old_script)
      combined = <<'SCRIPT'
on theSplit(theString, theDelimiter)
    set oldDelimiters to AppleScript's text item delimiters
    set AppleScript's text item delimiters to theDelimiter
    set theArray to every text item of theString
    set AppleScript's text item delimiters to oldDelimiters
    return theArray
end theSplit

on IsModernVersion(version)
    set myArray to my theSplit(version, ".")
    set major to item 1 of myArray
    set minor to item 2 of myArray
    set veryMinor to item 3 of myArray

    if major < 2 then
        return false
    end if
    if major > 2 then
        return true
    end if
    if minor < 9 then
        return false
    end if
    if minor > 9 then
        return true
    end if
    if veryMinor < 20140903 then
        return false
    end if
    return true
end IsModernVersion

on NewScript()
    return "%{new_script}"
end NewScript

on OldScript()
    -- Return the legacy script as a string here; what follows is an example.
    return "%{old_script}"
end OldScript

tell application "iTerm"
    if my IsModernVersion(version) then
        set myScript to my NewScript()
    else
        set myScript to my OldScript()
    end if
end tell

set fullScript to "tell application \"iTerm\"
" & myScript & "
end tell"

run script fullScript
SCRIPT
      combined % {new_script: "#{new_script.gsub('"', '\"')}", old_script: "#{old_script.gsub('"', '\"')}"}
    end
  end
end
