require_relative "helper"
require_relative '../lib/jepeto/helpers/jekyll_post_helper'
require "date"
require 'yaml'
require 'fileutils'

# TODO: Write a test to check that the layout used as default actually exists
class TestJekyllPost < MiniTest::Unit::TestCase
  include Jepeto::JekyllPostHelper

  def setup
    @options_list = options_list
    @temp_dir = '/tmp'
    @options = default_options
    @post = Jepeto::JekyllPost.new(@options)
    @required_constants = %w[HARDCODED_DEFAULT_OPTIONS VALID_FILE_EXTENSIONS POST_DIRECTORY]
  end

  def test_options_should_be_retrievable
    @options_list.dup.push('title', 'options').each do |option|
      assert_equal true, @post.respond_to?(option), "#{option.capitalize} should be retrievable"
    end
  end

  def test_Jepeto_should_have_the_right_constants_defined
    @required_constants.each do |constant|
      flunk "The #{constant} constant is not defined" unless Jepeto.const_defined?(constant.to_sym)
    end

    pass
  end

  def test_should_get_the_default_option_if_wasnt_passed
    @options_list.each do |option|
      # It is necessary to add a default title so that an ArgumentError is not raised
      post = Jepeto::JekyllPost.new(@options.merge(option.to_sym => nil, title: "The Title"))
      options = get_options_from_jprc

      if !options.empty? && !options[option.to_sym].nil?
        assert_equal options[option.to_sym], post.options[option.to_sym]
      else
        assert_equal Jepeto::HARDCODED_DEFAULT_OPTIONS[option.to_sym], post.options[option.to_sym]
      end
    end
  end

  # The title is the only option that is not optional. How ironic.
  # Without the title the name of the post file can't be generated.
  # On the other hand, the date and the extension can be given default values
  # (the current date and "markdown" respectively)
  def test_title_is_mandatory
    config_file = File.expand_path("~/.jprc")

    if File.exists?(config_file)
      options = get_options_from_jprc
      if options[:title].nil? || options[:title].empty?
        assert_raises(ArgumentError) { Jepeto::JekyllPost.new(@options.merge(title: nil)) }
      end
    else
      assert_raises(ArgumentError) { Jepeto::JekyllPost.new(@options.merge(title: nil)) }
    end
  end

  # The date should have the following format:
  # yyyy-mm-dd
  # ie: 2011-10-15
  def test_date_should_have_the_right_format
    assert_match(/^\d{4}(?:-\d{2}){2}$/, @post.date)
  end

  def test_extension_should_be_valid
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

  def test_fail_if_posts_folder_not_found_and_no_location_option_was_passed
    # Make sure to go in a dir with no posts dir
    FileUtils.rm_rf(File.join(@temp_dir, Jepeto::POST_DIRECTORY)) if File.directory?(@temp_dir + '/' + Jepeto::POST_DIRECTORY)
    Dir.chdir(@temp_dir)
    assert_raises(RuntimeError, "Unable to find the posts directory") { Jepeto::JekyllPost.new(@options.merge(debug: false)) }
  end

  def test_there_is_a_debug_option
    assert_includes @post.options, :debug
  end

  def test_there_is_a_way_to_test_if_debug_mode_is_on
    assert Jepeto::JekyllPost.private_method_defined?(:debug?), "The debug? private method should be defined"
  end

  def test_get_out_of_posts_dir
    Dir.chdir(@temp_dir)

    # Start fresh
    FileUtils.rm_rf(Jepeto::POST_DIRECTORY) if File.directory?(Jepeto::POST_DIRECTORY)
    Dir.mkdir(Jepeto::POST_DIRECTORY)
    Dir.chdir(Jepeto::POST_DIRECTORY)

    post = Jepeto::JekyllPost.new(@options.merge(location: File.join(@temp_dir, Jepeto::POST_DIRECTORY)))
    post.save!

    assert_equal false, Dir.getwd.include?(Jepeto::POST_DIRECTORY), "You shouldn't be in the posts directory"
  end

  def test_raise_an_exception_if_file_with_the_same_name_already_exists
    Dir.chdir(@temp_dir)
    FileUtils.rm_rf(Jepeto::POST_DIRECTORY) if File.directory?(Jepeto::POST_DIRECTORY)
    Dir.mkdir(Jepeto::POST_DIRECTORY)

    file = File.join(Jepeto::POST_DIRECTORY, "#{default_options.fetch(:date)}-#{slugalize(default_options.fetch(:title))}.#{default_options.fetch(:extension)}")
    File.new(file, 'w')

    assert_raises(RuntimeError) { Jepeto::JekyllPost.new(@options).save! }
  end

  def test_make_sure_post_dir_is_writable
    Dir.chdir(@temp_dir)
    FileUtils.rm_rf(Jepeto::POST_DIRECTORY) if File.directory?(Jepeto::POST_DIRECTORY)
    Dir.mkdir(Jepeto::POST_DIRECTORY, 0522)

    assert_raises(RuntimeError) { Jepeto::JekyllPost.new(@options).save! }
  end

  def test_create_post_file
    Dir.chdir(@temp_dir)
    FileUtils.rm_rf(Jepeto::POST_DIRECTORY) if File.directory?(Jepeto::POST_DIRECTORY)
    Dir.mkdir(Jepeto::POST_DIRECTORY)

    file = File.join(Jepeto::POST_DIRECTORY, "#{default_options.fetch(:date)}-#{slugalize(default_options.fetch(:title))}.#{default_options.fetch(:extension)}")
    post = Jepeto::JekyllPost.new(@options).save!

    assert File.exists?(file), "No post file was created"
  end

  def test_yaml_front_matter_should_be_written_to_the_file
    Dir.chdir(@temp_dir)
    FileUtils.rm_rf(Jepeto::POST_DIRECTORY) if File.directory?(Jepeto::POST_DIRECTORY)
    Dir.mkdir(Jepeto::POST_DIRECTORY)

    file = File.join(Jepeto::POST_DIRECTORY, "#{default_options.fetch(:date)}-#{slugalize(default_options.fetch(:title))}.#{default_options.fetch(:extension)}")
    post = Jepeto::JekyllPost.new(@options)
    post.save!

    yfm = ""
    File.open(file) do |file|
      while line = file.gets
        yfm << line
        yfm << "\n"
      end
    end

    refute yfm.empty?, "YAML Front Matter should be added to the post file"

    # a valid YAML Front Matter contains at least a layout and a title
    converted_yaml = YAML.load(yfm)
    assert converted_yaml.include?("title")
    assert converted_yaml.include?("layout")
  end

  def test_save_method_should_return_full_path_to_post_file
    Dir.chdir(@temp_dir)
    FileUtils.rm_rf(Jepeto::POST_DIRECTORY) if File.directory?(Jepeto::POST_DIRECTORY)
    Dir.mkdir(Jepeto::POST_DIRECTORY)

    file = File.join(Jepeto::POST_DIRECTORY, "#{default_options.fetch(:date)}-#{slugalize(default_options.fetch(:title))}.#{default_options.fetch(:extension)}")
    post = Jepeto::JekyllPost.new(@options)
    full_path = post.save!

    assert_equal File.expand_path(file), full_path
  end

  private

  def default_options
    {
      layout:     'default',
      title:      'The Title',
      extension:  'markdown',
      published:  false,
      date:       Date.today.to_s,
      location:   Dir.getwd,
      debug:      true
    }
  end

  def options_list
    %w[date extension published layout]
  end

  def get_options_from_jprc
    options = ""

    config_file = File.expand_path("~/.jprc")
    if File.exists?(config_file)
      File.open(config_file, 'r') do |file|
        while line = file.gets
          options << line
        end
      end
      options = YAML.load(options)
      options = options.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    end

    options
  end
end
