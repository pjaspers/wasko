# coding: utf-8

require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'wasko'
include Wasko
