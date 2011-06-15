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
    # them, except to fall back to brittle GUI scripting
    # and I'm not really looking forward to doing that.
    #
    # So that's why you should use iTerm2.
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
