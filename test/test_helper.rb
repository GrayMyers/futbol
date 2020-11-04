require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
SimpleCov.start
Dir["./lib/*"].each{|file| require file}
