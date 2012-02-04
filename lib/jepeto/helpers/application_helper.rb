module Jepeto
  module ApplicationHelper
    def slugalize(string)
      string = string.dup
      string.gsub!(/[^\x00-\x7F]+/, '')     # Remove non-ASCII (e.g. diacritics).
      string.gsub!(/[^a-z0-9\-_\+]+/i, '-') # Turn non-slug chars into the separator.
      string.gsub!(/-{2,}/, '-')            # No more than one of the separator in a row.
      string.gsub!(/^-|-$/, '')             # Remove leading/trailing separator.
      string.downcase!
      string
    end
  end
end
