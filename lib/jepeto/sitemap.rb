module Jepeto
  class Sitemap
    SITE_DIRECTORY = '_site'

    def initialize
      check_if_site_folder_is_valid!
    end

    def generate!(url = nil)
      # Move out of the site directory if necessary
      Dir.chdir('..') if Dir.getwd.include?(SITE_DIRECTORY)

      sitemap_file = File.join(SITE_DIRECTORY, 'sitemap.xml')
      files = list_files
      files.delete_if { |file| File.directory?(file) || File.extname(file) != '.html' }
      files.collect { |file| file.slice! '_site/' }

      @url = url || get_site_url

      # Write the sitemap.xml file
      File.open(sitemap_file, 'w') do |file|
        file.puts generate_xml! files
      end

      File.expand_path(sitemap_file)
    end

    private

    def check_if_site_folder_is_valid!
      unless File.exists?(SITE_DIRECTORY)
        raise SiteDirectoryDoesNotExistError, "The #{SITE_DIRECTORY} folder doesn't exist"
      end

      unless File.writable?(SITE_DIRECTORY)
        raise SiteDirectoryNotWriteableError, "The #{SITE_DIRECTORY} is not writable"
      end
    end

    def list_files
      Dir.glob("#{SITE_DIRECTORY}/**/*")
    end

    def get_site_url
      # FIXME: Duplicated code, check jekyll_post.rb
      config_file = File.expand_path('~/.jprc')
      if File.exists?(config_file)
        # Get the post hash from the .jprc file
        jprc_options = YAML.load(File.open(config_file))

        # Delete post and page options
        jprc_options.delete_if { |option| !option.keys.include?('sitemap') }

        # Get the url from the options
        site_url = jprc_options.first.fetch('sitemap').fetch('url')

        if site_url[-1] == '/'
          site_url.slice!(-1)
        end

        site_url + "/"
      end
    end

    def generate_xml!(files)
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.urlset('xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
          files.each do |file|
            xml.url {
              xml.loc "#{@url}#{file}"
            }
          end
        }
      end

      builder.to_xml
    end
  end
end
