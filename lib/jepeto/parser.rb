module Jepeto

  class OptionsParser

    def self.parse!(the_real_title = nil)
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

        opt.on( "-t", "--title=TITLE", "The post title.") do |title|
          options[:title] = title
        end

        opt.on( "-e", "--extension=EXTENSION", "The extension of the post file.") do |extension|
          options[:extension] = extension
        end

        # TODO: Add the date option

        opt.on( "--draft=DRAFT", "Whether or not to create a draft post") do |draft|
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

      if options[:title].nil? && !the_real_title.nil? && !the_real_title.empty?
        options[:title] = the_real_title
      end

      option_parser.parse!
      options
    end
  end
end
