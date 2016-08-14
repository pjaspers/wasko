module Wasko
  # Support for iTerm2 version 3 and later (yes, I agree, their naming is erm,
  # inspired).
  class Iterm < Terminal
    def name
      "iTerm.app"
    end

    # iTerm v3 no longer supports setting and getting the font
    ["font name",
     "font size"
    ].each do |noun|
      define_method(getter_for_applescript_noun(noun)) {}
      define_method(setter_for_applescript_noun(noun)) {|_color| }
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
    tell current session of current window
        set #{object} to #{value}
    end tell
end tell
SCRIPT
    end

    def get_script(object)
      <<SCRIPT
tell application "iTerm"
    tell current session of current window
        get #{object}
    end tell
end tell
SCRIPT
    end
  end
end
