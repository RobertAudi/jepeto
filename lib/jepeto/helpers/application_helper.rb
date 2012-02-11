module Jepeto
  module ApplicationHelper
    # Create a slug out of a string
    def slugalize(string)
      string = string.dup
      string.gsub!(/[^\x00-\x7F]+/, '')     # Remove non-ASCII (e.g. diacritics).
      string.gsub!(/[^a-z0-9\-_\+]+/i, '-') # Turn non-slug chars into the separator.
      string.gsub!(/-{2,}/, '-')            # No more than one of the separator in a row.
      string.gsub!(/^-|-$/, '')             # Remove leading/trailing separator.
      string.downcase!
      string
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
  end
end
