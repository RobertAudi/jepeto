require_relative 'helpers/application_helper'

module Jepeto

  class JekyllPost
    include Jepeto::ApplicationHelper

    # Don't edit this constant hash!
    # This can be overridden by the DEFAULT_OPTIONS hash
    # or by options passed in by the user.
    HARDCODED_DEFAULT_OPTIONS = {
      date:      Date.today.to_s,
      extension: 'markdown',
      published: false,
      layout:    'default'
    }

    # This array should contain all the file extensions supported by jekyll
    VALID_FILE_EXTENSIONS = [
      'markdown', 'mdown', 'md',
      'textile'
    ]

    POST_DIRECTORY = "_posts"

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

    def save!

      Dir.chdir('..') if Dir.getwd.include?(POST_DIRECTORY)
      post_file = File.join(POST_DIRECTORY, self.filename)

      unless File.writable?(POST_DIRECTORY)
        raise "The post directory is not wriatble"
        exit
      end

      if File.exists?(post_file)
        raise NameError, "A post file with the same name already exists"
        exit
      end

      File.open(post_file, 'w') do |file|
        file.puts yaml_front_matter
      end

      File.expand_path(post_file)
    end

    private

    def define_instance_variables!
      %w[slug filename yaml_front_matter].each do |attribute|
        instance_variable_set("@#{attribute}", nil)
      end
    end

    def check_options(options)
      # If the user defined default values via the DEFAULT_OPTIONS constant
      # replace all the nil values with default values.

      jprc_options = ""
      config_file = File.expand_path("~/.jprc")
      if File.exists?(config_file)
        File.open(config_file, 'r') do |file|
          while line = file.gets
            jprc_options << line
          end
        end
         jprc_options = YAML.load(jprc_options)
         jprc_options = jprc_options.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

         options = merge_options(options, jprc_options)
      end

      # If there are still some nil values, replace them with default values from
      # the HARDCODED_DEFAULT_OPTIONS constant.
      options = merge_options(options, HARDCODED_DEFAULT_OPTIONS)

      options[:extension] = check_extension(options[:extension])

      # At this point, the only value that could potentially
      # be nil or empty is the title.
      # That is unacceptable!!
      if options[:title].nil? || options[:title].empty?
        raise ArgumentError, "The post file can't be created without a title!!!"
      end

      options
    end

    def merge_options(options, default_options)
      default_options.each do |option, value|
        if options[option].nil?
          options[option] = value
        end
      end

      options
    end

    def check_extension(extension)
      extension.slice!(0) if extension[0] == '.'
      raise "#{extension} is not a valid extension." unless VALID_FILE_EXTENSIONS.include?(extension)

      @extension = extension
    end

    def generate_slug
      @slug = slugalize(title)
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
