# General requirements
require "date"
require "yaml"

# Debug Shite
require 'ap'

# Personal requirements
require_relative './jepeto/jekyll_post'

module Jepeto

  DEFAULT_OPTIONS = {
    layout: 'post',
    extension: 'markdown',
    published: true
  }
end
