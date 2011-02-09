module Jepeto

  class JekyllPost
    def initialize(options)
      if options[:title].nil? || options[:title].empty?
        raise ArgumentError, 'invalid argument passed (valid title required)'
      end

      @options = options
    end


  end
end
