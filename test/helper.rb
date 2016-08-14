# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'wasko'
include Wasko

def test_applescripts(terminal, color_nouns, other_nouns_with_values)
  describe "running applescript" do
    let(:subject) { terminal }

    color_nouns.each do |noun|
      getter_method_name = Terminal.getter_for_applescript_noun(noun)
      setter_method_name = Terminal.setter_for_applescript_noun(noun)

      it "can set '#{noun}'" do
        Applescript.run { subject.public_send(setter_method_name, "red") }
      end

      it "can get '#{noun}'" do
        Applescript.run { subject.public_send(getter_method_name) }
      end

      it "can set and get '#{noun}' and see the value is updated" do
        expected_color = "65535, 0, 0"
        Applescript.run { subject.public_send(setter_method_name, "red") }
        assert_equal expected_color, Applescript.run { subject.public_send(getter_method_name) }
      end
    end

    other_nouns_with_values.each do |noun, value|
      getter_method_name = Terminal.getter_for_applescript_noun(noun)
      setter_method_name = Terminal.setter_for_applescript_noun(noun)

      it "can set '#{noun}'" do
        Applescript.run { subject.public_send(setter_method_name, value) }
      end

      it "can get '#{noun}'" do
        Applescript.run { subject.public_send(getter_method_name) }
      end

      it "can set and get '#{noun}' and see the value is updated" do
        Applescript.run { subject.public_send(setter_method_name, value) }
        assert_equal value.to_s, Applescript.run { subject.public_send(getter_method_name) }
      end
    end
  end
end
