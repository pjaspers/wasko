module Wasko
  # Adds support for [iTerm2](http://code.google.com/p/iterm2/)
  class Iterm


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
