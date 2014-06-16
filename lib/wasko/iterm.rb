module Wasko
  # Adds support for [iTerm2](http://code.google.com/p/iterm2/)
  class Iterm

    def self.normal_text_color
      foreground_color
    end

    def self.font_name
      'Not supported'
    end

    def self.font_size
      'Not supported'
    end

    def self.bold_text_color
      bold_color
    end

    # Terminal.app uses a slightly different terminology
    def self.set_normal_text_color(color)
      set_foreground_color color
    end

    def self.set_bold_text_color(color)
      set_bold_color color
    end

    # iTerm doesn't have a way to get back the original color,
    # falling back to black for now.
    #
    # Returns an applescript color
    def self.startup_background_color
      "{0,0,0}"
    end

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
tell application "iTerm"
  set #{object} of current session of current terminal to #{value}
end tell
SCRIPT
    end

    # Getter
    #
    #      Wasko::Terminal.get_script("background color")
    #
    def self.get_script(object)
      <<SCRIPT
tell application "iTerm"
  get #{object} of current session of current terminal
end tell
SCRIPT
    end

  end
end
