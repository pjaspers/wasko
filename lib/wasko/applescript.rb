require "open3"

module Wasko
  class Applescript
    # Runs a piece of Applescript,
    #
    #      Wasko::Applescript.run do
    #        "set ten_and_ten to 10 + 10"
    #      end
    #      => "20"
    #
    # Since Applescript has a nasy bit of littering its return values with `\n`,
    # already escaping those.
    #
    # If the Applescript can't be executed a `Wasko::ApplescriptError` will be raised.
    def self.run
      original = yield
      stdout_str, stderr_str, status = Open3.capture3("osascript", :stdin_data => original)
      if stderr_str.length > 0
        fail ApplescriptError.new(stderr_str)
      end
      stdout_str.strip!
    end
  end
end
