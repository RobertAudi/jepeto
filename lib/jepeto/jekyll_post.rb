require_relative 'helpers/jekyll_post_helper'

module Jepeto

  # Don't edit this constant hash!
  # This can be overridden by the DEFAULT_OPTIONS hash
  # or by options passed in by the user.
  HARDCODED_DEFAULT_OPTIONS = {
    date:      Date.today.to_s,
    extension: 'markdown',
    published: false,
    layout:    'default',
    location:  '.',
    debug:     false
  }

  # This array should contain all the file extensions supported by jekyll
  VALID_FILE_EXTENSIONS = [
    'markdown', 'mdown', 'md',
    'textile'
  ]

  POST_DIRECTORY = "_posts"

  class JekyllPost
    include Jepeto::JekyllPostHelper
    
    attr_reader :options

    def initialize(options)
      define_instance_variables!
      @options = check_options(options)
    end

    # Automagically create custom accessor methods for each option
    %w[title date extension published layout].each do |option|
      define_method(option) do
        instance_variable_get("@options").fetch(option.to_sym)
      end
    end

    # Automagically create custom accessor methods for the other attributes
    %w[slug filename yaml_front_matter].each do |attribute|
      define_method(attribute) do
        send "generate_#{attribute}" if instance_variable_get("@#{attribute}").nil?
      end
    end

    private

    def define_instance_variables!
      %w[slug filename yaml_front_matter location].each do |attribute|
        instance_variable_set("@#{attribute}", nil)
      end
    end

    def check_options(options)
      # If the user defined default values via the DEFAULT_OPTIONS constant
      # replace all the nil values with default values.
      if Jepeto.const_defined?(:DEFAULT_OPTIONS)
        options = merge_options(options, Jepeto::DEFAULT_OPTIONS)
      end

      # If there are still some nil values, replace them with default values from
      # the HARDCODED_DEFAULT_OPTIONS constant.
      options = merge_options(options, Jepeto::HARDCODED_DEFAULT_OPTIONS)

      options[:extension] = check_extension(options[:extension])

      # At this point, the only value that could potentially
      # be nil or empty is the title.
      # That is unacceptable!!
      if options[:title].nil? || options[:title].empty?
        raise ArgumentError, "The post file can't be created without a fucking title!!!"
      end

      set_location!(options[:location], options[:debug])

      options
    end

    def debug?
      @options[:debug]
    end

    def merge_options(options, default_options)
      default_options.each do |option, value|
        if options[option].nil?
          options[option] = value
        end
      end

      options
    end

    def set_location!(location, debug = false)
      # location of the _posts folder not locaation of the post file!!
      location ||= get_default_location

      # Remove the trailling slash if they're there
      location.chomp!('/')

      if (location[-5] == Jepeto::POST_DIRECTORY && File.directory?(location))
        location.chomp!(Jepeto::POST_DIRECTORY)
      else
        raise "Unable to find the posts directory" unless (debug || File.directory?(location.chomp('/') + '/' + Jepeto::POST_DIRECTORY))
      end

      # Make sure there isn't a trailling slash
      @location ||= location.chomp('/')
    end

    def get_default_location
      if Jepeto.const_defined?(:DEFAULT_OPTIONS) && !Jepeto::DEFAULT_OPTIONS[:location].nil?
        location = Jepeto::DEFAULT_OPTIONS[:location]
      else
        location = Jepeto::HARDCODED_DEFAULT_OPTIONS[:location]
      end

      File.join(location, Jepeto::POST_DIRECTORY)
    end

    def check_extension(extension)
      extension.slice!(0) if extension[0] == '.'
      raise "#{extension} is not a valid extension." unless VALID_FILE_EXTENSIONS.include?(extension)

      @extension = extension
    end

    def generate_slug
      @slug = slugify(title)
    end

    def generate_filename
      "#{date}-#{slug}.#{extension}"
    end

    def generate_yaml_front_matter
      @yaml_front_matter = {}
      @yaml_front_matter['layout']    = layout
      @yaml_front_matter['title']     = title
      @yaml_front_matter['published'] = published
      @yaml_front_matter = @yaml_front_matter.to_yaml
      @yaml_front_matter << "---\n"
    end

  end
end
