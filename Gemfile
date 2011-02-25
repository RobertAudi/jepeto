source :rubygems
source :gemcutter

group :development do
  # Enforce a bundler version - we always want to be on the latest version
  # use lambda to avoid creating a top-level variable
  lambda do
    min_bundler_version = '1.0.10'
    # There is a first pass and a second pass with different settings
    if Gem::Version.new(Bundler::VERSION) < Gem::Version.new(min_bundler_version)
      fail "Bundler version #{min_bundler_version} or greater required.  Please run 'gem update bundler'."
    end 
  end.call
end

group :test do
  gem 'minitest', '2.0.2'
  gem 'ZenTest', '4.5.0'
  gem 'mynyml-redgreen', '0.7.1'
end
