require_relative "helper"

class TestJepeto < MiniTest::Unit::TestCase

  def setup
    @options_list = options_list
    @options = Jepeto::DEFAULT_OPTIONS
  end

  def test_there_should_be_a_default_options_constant_hash
    assert_equal true, Jepeto.const_defined?(:DEFAULT_OPTIONS)
    assert_equal Hash, @options.class
  end

  def test_default_options_constant_should_contain_default_options
    @options_list.each do |option|
      assert_equal true, @options.include?(option.to_sym), "The DEFAULT_OPTIONS hash should include the #{option} option"
    end
  end

  def test_the_draft_option_should_be_a_boolean
    assert_equal true, (@options[:draft].is_a?(TrueClass) || @options[:draft].is_a?(FalseClass))
  end

  def test_all_options_except_for_draft_should_be_non_empty_strings
    @options.each do |option, value|
      next if option == :draft
      assert_equal String, value.class, "#{option.to_s.capitalize} should be a String, not a #{value.class}"
      assert_equal false, value.empty?, "#{option.to_s.capitalize} can't be empty"
    end
  end

  def test_date_should_have_the_right_format
    assert_match /^\d{4}(?:-\d{2}){2}$/, @options[:date]
  end

  def test_extension_should_be_valid
    # Make sure that there is a valid VALID_EXTENSIONS constant
    # I don't think it's necessary to create a seperate test for that.
    assert_equal true, Jepeto.const_defined?(:VALID_EXTENSIONS), "The VALID_EXTENSIONS constant doesn't exists"
    assert_equal true, Jepeto::VALID_EXTENSIONS.is_a?(Array), "The VALID_EXTENSIONS constant should be an array not a #{Jepeto::VALID_EXTENSIONS.class}"

    @options[:extension].slice!(0) if @options[:extension][0] == '.'
    assert_equal true, Jepeto::VALID_EXTENSIONS.include?(@options[:extension])
  end

  private

  def options_list
    %w[title date extension draft layout]
  end
end
