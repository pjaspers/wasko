require 'helper'

class TestTerminal < Test::Unit::TestCase
  context "defining dynamic methods" do
    setup do
      @terminal = Wasko::Terminal
    end

    %w(background_color normal_text_color font_size font_name cursor_color).each do |method|
      should "support getter #{method}" do
        assert @terminal.respond_to? method.to_sym
      end

      should "support setter set_#{method}" do
        assert @terminal.respond_to? "set_#{method}".to_sym
      end
    end
  end

  # TODO: Mock the `Wasko::Applescript` and see if the
  # actual script gets called.
end
