# General requirements
require "date"
require "yaml"
require "optparse"

# Personal requirements
require_relative "./jepeto/version"
require_relative "./jepeto/jekyll_post"
require_relative "./jepeto/option_parser"

module Jepeto

  DEFAULT_OPTIONS = {
    layout: "post",
    extension: "markdown",
    published: true
  }
end
