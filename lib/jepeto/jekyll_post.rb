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
    attr_reader :options

    def initialize(options)
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
        send "generate_#{attribute}" unless instance_variable_defined?("@#{attribute}")
      end
    end

    private

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

      unless options[:debug]
        # The posts file can't be created if the posts directory isn't found
        raise "Unable to find the posts directory" unless location_found?(options[:location])
      end

      options
    end

    def debug?
      @options[:debug]
    end

    def location_found?(location)
      File.directory?(File.join(location, Jepeto::POST_DIRECTORY))
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
      @slug = title.downcase.strip.gsub(/[ _\.-]+/, '-')
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
    end

  end
end
