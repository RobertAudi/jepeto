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
      published: true,
      layout:    'default'
    }

    # This array should contain all the file extensions supported by jekyll
    VALID_FILE_EXTENSIONS = [
      'markdown', 'mdown', 'md',
      'textile'
    ]

    POST_DIRECTORY = "_posts"

    def initialize(options)
      @options = check_options(options)
      generate_file_options!
    end

    def save!
      Dir.chdir("..") if Dir.getwd.include?(POST_DIRECTORY)
      post_file = File.join(POST_DIRECTORY, @options[:filename])

      # OPTIMIZE: Maybe those two checks should go in the initialize method
      unless File.writable?(POST_DIRECTORY)
        raise PostDirectoryNotWritableError, "The post directory is not writable"
        exit
      end

      if File.exists?(post_file)
        raise PostFileAlreadyExistsError, "The post file already exists"
        exit
      end

      File.open(post_file, 'w') do |file|
        file.puts @options[:yaml_front_matter]
      end

      File.expand_path(post_file)
    end

    private

    def check_options(options)
      # Check the .jprc file

      config_file = File.expand_path("~/.jprc")
      if File.exists?(config_file)
        begin
          # BUG: Don't get the first element of the array, the user may order the preferences differently!
          # Get the post hash from the .jprc file
          jprc_options = YAML.load(File.open(config_file)).first.fetch("post")

          # Convert the hash keys to symbols
          jprc_options = jprc_options.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

          # Merge options
          # See the documentation for the
          # merge_options method for more info
          options = merge_options(options, jprc_options)
        rescue
          raise UnableToParseJpRcError, "Could not parse the .jprc file"
        end
      end

      # Remove any remaining nil values by
      # merging the hardcoded default options
      options = merge_options(options, HARDCODED_DEFAULT_OPTIONS)

      # Finally validate the options hash before returning it to the initialie method
      validate_options!(options)

      options
    end

    def validate_options!(options)
      # Validate date
      # The date must be in the format YYYY-MM-DD
      unless options[:date] =~ /^\d{4}-\d{2}-\d{2}$/
        raise InvalidDateFormatError, "The date must be in the format YYYY-MM-DD"
        exit
      end

      # Validate the layout
      # Basically if the layout doesn't exist it's invalid
      layouts = Dir.glob("_layouts/*")
      layouts.each do |layout|
        layout.gsub!(/^_layouts\/(.*)\..*$/, '\1')
      end

      unless layouts.include?(options[:layout])
        raise InvalidLayoutError, "The layout you specified doens't exist"
        exit
      end

      # Validate extension
      # Remove the dot of the extension if it's present
      options[:extension].slice!(0) if options[:extension][0] == '.'
      unless VALID_FILE_EXTENSIONS.include?(options[:extension])
        raise InvalidFileExtensionError, "#{options[:extension]} is not a valid post extension."
        exit
      end

      # Validate title
      if options[:title].nil? || options[:title].empty?
        raise EmptyOrNilTitleError, "The post file can't be created without a title!!!"
        exit
      end

      # Validate the published state
      # it can either be true or false
      unless [TrueClass, FalseClass].include? options[:published].class
        raise InvalidBooleanTypeError, "The published state must be either true or false"
        exit
      end
    end

    # All nil keys in the options hash will
    # be replaced by the corresponding keys
    # from the new_options hash
    def merge_options(options, new_options)
      new_options.each do |option, value|
        if options[option].nil?
          options[option] = value
        end
      end

      options
    end

    def generate_file_options!
      @options[:slug] = slugalize(@options[:title])
      @options[:filename] = "#{@options[:date]}-#{@options[:slug]}.#{@options[:extension]}"
      @options[:yaml_front_matter] = generate_yaml_front_matter
    end

    def generate_yaml_front_matter
      yaml_front_matter = {}
      yaml_front_matter['layout']    = @options[:layout]
      yaml_front_matter['title']     = @options[:title]
      yaml_front_matter['published'] = @options[:published]
      yaml_front_matter = yaml_front_matter.to_yaml
      yaml_front_matter << "---\n"
      yaml_front_matter
    end
  end
end
