require_relative "helper"
require "date"

class TestJekyllPost < MiniTest::Unit::TestCase

  def setup
    @options = {
      layout:     'default',
      title:      'The Title',
      extension:  'markdown',
      draft:      false,
      date:       Date.today.to_s
    }
  end

  def test_title_should_not_be_empty
    @options[:title] = ''
    assert_raises(ArgumentError) { Jepeto::JekyllPost.new(@options) }
  end

  def test_title_should_not_be_nil
    @options[:title] = nil
    assert_raises(ArgumentError) { Jepeto::JekyllPost.new(@options) }
  end

end
