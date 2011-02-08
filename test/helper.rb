# I need to use require_relative because '.' in not
# in the LOAD_PATH anymore in Ruby 1.9.2
require_relative "../lib/jepeto.rb"

# Use MiniTest from RubyGems not the builtin one
# so that I can use minitest/pride and get colors.
gem 'minitest'

require "minitest/unit"
require "minitest/pride" # Colors!!
#
# Note to self: Instead of the line below,
# I could justr equire 'minitest/autorun'
MiniTest::Unit::autorun
