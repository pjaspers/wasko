module Wasko
  # Support for OSX's builtin Terminal.app
  class TerminalApp < Terminal
    def name
      "Terminal.app"
    end

    # Unsupported calls
    # Since Apple hasn't implemented them, no way to set
    # them, except to fall back to brittle GUI scripting
    # and I'm not really looking forward to doing that.
    #
    # Rendering them harmless by removing their implementation.
    ["selected text color",
    "selection color",
    "ansi black color",
    "ansi red color",
    "ansi green color",
    "ansi yellow color",
    "ansi blue color",
    "ansi magenta color",
    "ansi cyan color",
    "ansi white color"].each do |noun|
      define_method(getter_for_applescript_noun(noun)) {}
      define_method(setter_for_applescript_noun(noun)) {|_color| }
    end

    # ## Utility methods
    #
    # Setter
    #
    #      Wasko::TerminalApp.new.set_script("background color", "{65535, 0, 0}")
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
