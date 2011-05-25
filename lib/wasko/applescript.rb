module Wasko
  class Applescript
    # Runs a piece of Applescript,
    #
    #      Wasko::Applescript.run do
    #        "set ten_and_ten to 10 + 10"
    #      end
    #      => "20"
    #
    # Since Applescript has a nasy bit of littering its
    # return values with `\n`, already escaping those.
    def self.run
        value = `/usr/bin/osascript -e "#{yield.gsub('"', '\"')}"`
        value.gsub("\n", '')
      end
  end
end
