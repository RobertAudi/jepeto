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

  def test_title_is_not_empty
    @options[:title] = ''
    post = JekyllPost.new(@options)
    assert_equal false, post
  end

  def test_title_is_not_nil
    @options[:title] = nil
    post = JekyllPost.new(@options)
    assert_equal false, post
  end

end
