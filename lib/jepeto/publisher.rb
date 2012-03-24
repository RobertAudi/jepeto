module Jepeto
  class Publisher

    def initialize
    end

    # Publish a post
    def self.publish!(draft)
      raise PostFileDoesntExistError unless File.exists?(draft)

      # Remove the "published: false" line from the file
      post_body_lines = File.readlines(draft)
      post_body_lines.delete_if { |line| line =~ /\Apublished:\s*false\Z/ }
      File.open(draft, 'w') do |f|
        post_body_lines.each { |line| f.puts(line) }
      end

      draft
    end

    # Get a list of draft posts
    def self.drafts
      Dir.chdir("..") if Dir.getwd.include?(Jepeto::JekyllPost::POST_DIRECTORY)
      posts = Dir.glob("#{Jepeto::JekyllPost::POST_DIRECTORY}/*")
      posts.delete_if do |post|
        the_post_is_a_draft = true
        file = File.new(post)
        file.each do |line|
          if line =~ /\Apublished:\s*false\Z/
            the_post_is_a_draft = true
            break
          else
            the_post_is_a_draft = false
          end
        end
        file.close

        !the_post_is_a_draft
      end

      posts
    end

    # Extract the post title from its filename
    def self.normalize(draft)
      # 11 is the length of the date with dashes in the filename
      length_of_string_to_remove = Jepeto::JekyllPost::POST_DIRECTORY.length + 12
      length_of_extension = - (File.extname(draft).length + 1)
      draft = draft[length_of_string_to_remove..length_of_extension]
      draft.gsub(/-/, " ").capitalize
    end
  end
end
