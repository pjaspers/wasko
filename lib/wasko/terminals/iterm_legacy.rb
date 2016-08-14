module Wasko
  # Support for the old iTerm2 versions (pre version 3).
  class ItermLegacy < Terminal
    def name
      "iTerm.app"
    end

    # iTerm uses a slightly different terminology from Terminal.app, to make it easier
    # to share the same nouns across apps, working around this with adding the new noun
    # `foreground color` and remapping `normal text color` to this.
    apply_colour_noun("foreground color")

    def normal_text_color
      foreground_color
    end

    def set_normal_text_color(color)
      set_foreground_color(color)
    end

    def set_script(object, value)
      <<SCRIPT
tell application "iTerm"
  set #{object} of current session of current terminal to #{value}
end tell
SCRIPT
    end

    def get_script(object)
      <<SCRIPT
tell application "iTerm"
  get #{object} of current session of current terminal
end tell
SCRIPT
    end
  end
end
