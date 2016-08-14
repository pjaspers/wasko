require 'helper'

describe Wasko::TerminalApp do
  describe "Terminal contract" do
    before do
      @app = Wasko::TerminalApp.new
    end

    it "implements get_script" do
      refute_empty @app.get_script("background_color")
    end

    it "implements set_script" do
      refute_empty @app.set_script("background_color", "{65535, 0, 0}")
    end
  end

  if ENV["RUN_APPLESCRIPT"]
    color_nouns = ["cursor color", "background color", "normal text color"]
    other_nouns_with_values = {"font name" => "Menlo-Regular", "font size" => 10}
    test_applescripts(Wasko::TerminalApp.new, color_nouns, other_nouns_with_values)
  end
end