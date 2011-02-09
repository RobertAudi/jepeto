require_relative "helper"
require "date"

class TestJekyllPost < MiniTest::Unit::TestCase

  def setup
    @options = default_options
    @post = Jepeto::JekyllPost.new(@options)
  end

  def test_title_date_and_extension_should_be_valid
    %w[title date extension].each do |option|
      @options[option.to_sym] = ''
      assert_raises(ArgumentError) { Jepeto::JekyllPost.new(@options) }

      # Reset the options hash to be certain that the test fails for
      # the right reasons!
      @options = default_options

      @options[option.to_sym] = nil
      assert_raises(ArgumentError) { Jepeto::JekyllPost.new(@options) }

      # Reset the options hash so that other tests are not affected!
      @options = default_options
    end
  end

  def test_post_options_should_be_retrievable
    assert_kind_of Hash, @post.options
    refute_empty @post.options
  end

  def test_slug_should_be_generated
    refute_nil @post.options[:slug]
  end

  def test_slug_should_be_retrievable
    assert_equal @post.slug, @post.options[:slug]
  end

  def test_slug_should_have_the_right_format
    assert_match /^(?:[a-z0-9]+)(?:-[a-z0-9]+)*$/, @post.slug
  end


  # def test_filename_should_have_the_right_format
  #   assert_equal @post.filename, "#{@options[:date]}-#{@options[:slug]}.#{@options[:extension]}"
  # end

  private

  # This method can be used to reset the options hash.
  def default_options
    {
      layout:     'default',
      title:      'The Title',
      extension:  'markdown',
      draft:      false,
      date:       Date.today.to_s
    }
  end
end
