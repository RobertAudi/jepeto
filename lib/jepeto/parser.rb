module Jepeto
  class Parser
    VALID_QUERIES = ["post", "page", "sitemap"]

    attr_reader :options

    def parse!
      return parse_options, parse_query
    end

    private

    def parse_options
      options = {}

      option_parser = OptionParser.new do |opt|
        opt.banner  = "Usage: jp [title]"
        opt.separator "Usage: jp [title]"
        opt.separator ""
        opt.separator "The title has to be passed to create a new post file."
        opt.separator "If the title isn't passed as an option, the user will be"
        opt.separator "prompted to enter one."
        opt.separator ""
        opt.separator "Options"

        opt.on( "-e", "--extension=EXTENSION", "The extension of the post file.") do |extension|
          options[:extension] = extension
        end

        # TODO: Add the date option

        opt.on( "--draft", "Whether or not to create a draft post") do
          options[:draft] = true
        end

        opt.on( "-v", "--version", "Show version number") do
          puts "jekyll_post_generator version #{Jepeto::VERSION}"
          exit
        end

        opt.on( "-h", "--help", "Show this help message.") do
          puts option_parser
          exit
        end

        opt.separator ""
      end

      option_parser.parse!

      # NOTE: I need to set the instance variable in case the query is invalid
      # In that case an exception would be raised an the options would be lost
      @options = options
      options
    end

    # Parse and validate the query and the title/name of the post/page
    def parse_query
      if ARGV.empty?
        raise Jepeto::InvalidQueryTypeError, "The query can't be blank"
      else
        validate_query!
        {type: ARGV[0], id: ARGV[1]}
      end
    end

    def validate_query!
      # Check that there is a query
      if !VALID_QUERIES.include?(ARGV[0])
        raise Jepeto::InvalidQueryTypeError, "Invalid query"
      end

      # Check that there is a title/name
      # Sitemaps don't have a name
      if ARGV[1].nil? && ARGV[0] != "sitemap"
        raise Jepeto::InvalidNameOrTitleError, "Name/Title can't be blank"
      end
    end
  end
end
