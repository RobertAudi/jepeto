module Jepeto
  module JekyllPostHelper
    def slugify(string)
      string.downcase.strip.gsub(/[ _\.-]+/, '-')
    end
  end
end
