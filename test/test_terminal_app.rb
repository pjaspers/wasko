require 'helper'

describe Wasko::TerminalApp do
  describe "defining dynamic methods" do
    before do
      @terminal = Wasko::TerminalApp.new
    end

    %w(background_color normal_text_color font_size font_name cursor_color).each do |method|
      it "support getter #{method}" do
        assert @terminal.respond_to? method.to_sym
      end

      it "support setter set_#{method}" do
        assert @terminal.respond_to? "set_#{method}".to_sym
      end
    end
  end

  # TODO: Mock the `Wasko::Applescript` and see if the
  # actual script gets called.
end
