require_relative "helper"
require "date"
require 'yaml'

# TODO: Write a test to check that the layout used as default actually exists
class TestJekyllPost < MiniTest::Unit::TestCase

  def setup
    @options_list = options_list
    @options = default_options
    @post = Jepeto::JekyllPost.new(@options)
  end

  def test_options_should_be_retrievable
    @options_list.dup.push('title', 'options').each do |option|
      assert_equal true, @post.respond_to?(option), "#{option.capitalize} should be retrievable"
    end
  end

  def test_should_get_the_default_option_if_wasnt_passed
    @options_list.each do |option|
      # It is necessary to add a default title so that an ArgumentError is not raised
      post = Jepeto::JekyllPost.new(@options.merge(option.to_sym => nil, title: "The Title"))
      if Jepeto.const_defined?(:DEFAULT_OPTIONS) && Jepeto::DEFAULT_OPTIONS[option.to_sym].nil?
        assert_equal Jepeto::HARDCODED_DEFAULT_OPTIONS[option.to_sym], post.options[option.to_sym]
      else
        assert_equal Jepeto::DEFAULT_OPTIONS[option.to_sym], post.options[option.to_sym]
      end
    end
  end

  # The title is the only option that is not optional. How ironic.
  # Without the title the name of the post file can't be generated.
  # On the other hand, the date and the extension can be given default values
  # (the current date and "markdown" respectively)
  def test_title_is_mandatory
    assert_raises(ArgumentError) { Jepeto::JekyllPost.new(@options.merge(title: nil)) }
  end

  # The date should have the following format:
  # yyyy-mm-dd
  # ie: 2011-10-15
  def test_date_should_have_the_right_format
    assert_match(/^\d{4}(?:-\d{2}){2}$/, @post.date)
  end

  def test_extension_should_be_valid
    # ap @options.merge(extension: "docx")
    assert_raises(RuntimeError) { Jepeto::JekyllPost.new(@options.merge(extension: "docx")) }
  end

  # The slug should have the following format:
  # this-is-the-title
  def test_post_should_have_a_slug
    assert_match(/^(?:[a-z0-9]+)(?:-[a-z0-9]+)*$/, @post.slug)
  end

  # The filename should have the following format:
  # 2011-10-15-this-is-the-title.markdown
  def test_filename_should_have_the_right_format
    assert_match(/^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+(?:-[a-z0-9]+)*\.[a-z0-9]{2,8}$/, @post.filename)
  end

  def test_post_should_have_a_valid_yaml_front_matter
    YAML::load(@post.yaml_front_matter).each do |option, value|
      assert_equal @options[option.to_sym], value
    end
  end

  private

  def default_options
    {
      layout:     'default',
      title:      'The Title',
      extension:  'markdown',
      published:  false,
      date:       Date.today.to_s
    }
  end

  def options_list
    %w[date extension published layout]
  end
end
