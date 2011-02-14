require_relative './jepeto/jekyll_post'
require "date"

module Jepeto
  DEFAULT_OPTIONS = {
    title: 'The Title',
    date: Date.today.to_s,
    extension: 'markdown',
    draft: false,
    layout: 'default'
  }

  VALID_EXTENSIONS = [
    'markdown', 'mdown', 'md',
    'txt',
    'html', 'html5', 'xhtml', 'html'
    # TODO: Add textile and rdoc extensions
  ]
end
