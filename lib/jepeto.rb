# General requirements
require "date"
require "yaml"
require "optparse"

# Debug Shite
# Note: if in development environment, this might be the source of problems...
require "ap"

# Personal requirements
require_relative "./jepeto/jekyll_post"
require_relative "./jepeto/option_parser"

module Jepeto

  DEFAULT_OPTIONS = {
    layout: "post",
    extension: "markdown",
    published: true
  }
end
