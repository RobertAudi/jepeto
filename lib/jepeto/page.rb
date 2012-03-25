require_relative 'helpers/application_helper'

module Jepeto
  class Page
    include Jepeto::ApplicationHelper

    def initialize(options)
      @options = check_options(options)
    end

    def generate!
      # Make sure the user is in the right location
      unless File.exists?(Jepeto::JekyllPost::POST_DIRECTORY)
        raise NotInRightLocationError, 'You need to be in the root of your jekyll site to create pages'
      end

      if @options[:create_folder]
        folder = File.expand_path(File.join(Dir.getwd, @options[:name]))

        if File.exists?(folder)
          raise PageFolderAlreadyExistsError, 'The page folder already exists'
          exit
        end

        # Create the page folder to have pretty urls
        Dir.mkdir(folder)

        file = File.join(folder, 'index.html')
      else
        file = File.join(File.expand_path('.'), @options[:name])

        if File.exists?(file)
          raise PageFileAlreadyExistsError, 'The page file already exists'
          exit
        end
      end

      # Write the file and cache its path
      file = File.new(file, 'w').path

      file
    end

    private

    def check_options(options)
      # Merge in the options from the .jprc
      options = merge_options(options, get_jprc_options)

      # Extract the file extension if it's supplied
      options[:extension] = File.extname(options[:name])

      # If the user supplied an extension as part of the page name,
      # don't create a folder for the page.
      options[:create_folder] = (options.include?(:create_folder)) ? options[:create_folder]: options[:extension].empty?

      options
    end

    def get_jprc_options
      config_file = File.expand_path('~/.jprc')
      if File.exists?(config_file)
        begin
          # Get the post hash from the .jprc file
          options = YAML.load(File.open(config_file)).delete_if do |option|
            !option.include?("page")
          end

          # Try to get the .jprc options for pages
          options = (options.empty?) ? {} : (options.first["page"] || {})

          # Convert the hash keys to symbols
          options = options.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        rescue
          raise UnableToParseJpRcError, 'Could not parse the .jprc file'
        end
      end

      options
    end
  end
end
