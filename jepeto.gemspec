# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jepeto/version"

Gem::Specification.new do |s|
  s.name        = "jekyll_post_generator"
  s.version     = Jepeto::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aziz Light"]
  s.email       = ["aziiz.light+gem@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Jekyll Post Generator}
  s.description = %q{Generate jekyll posts painlessly}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
