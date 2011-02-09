module Jepeto

  class JekyllPost
    attr_reader :options

    def initialize(options)
      # The title, the date and the extension are the only options to be
      # mandatory! Without them, the post file's name can't be generated.
      %w[title date extension].each do |option|
        if options[option.to_sym].nil? || options[option.to_sym].empty?
          raise ArgumentError, "invalid argument passed (valid #{option} required)"
        end
      end

      @options = options

      generate!
    end

    def slug
      @options[:slug].nil? ? generate_slug : @options[:slug]
    end

    private

    def generate!
      generate_slug
    end

    def generate_slug
      @options[:slug] = @options[:title].downcase.strip.gsub(/[ _\.-]+/, '-')
    end
  end
end
