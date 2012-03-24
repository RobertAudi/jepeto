# General requirements
require 'date'
require 'yaml'
require 'optparse'
require 'nokogiri'

# Personal requirements
require_relative './jepeto/version'
require_relative './jepeto/jekyll_post'
require_relative './jepeto/page'
require_relative './jepeto/sitemap'
require_relative './jepeto/publisher'
require_relative './jepeto/exceptions'
require_relative './jepeto/parser'

module Jepeto
  # Check if the posts directory exists
  def posts_directory_exists?
    Dir.exists?(Jepeto::JekyllPost::POST_DIRECTORY)
  end

  # Check if the user is in the posts directory
  def in_posts_directory?
    Dir.getwd.chomp('/').rpartition('/').last == Jepeto::JekyllPost::POST_DIRECTORY
  end
end
