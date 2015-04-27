# encoding: utf-8
require File.expand_path('../lib/upyun-rb/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "upyun-rb"
  s.version     = Upyun::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Larry Zhao"]
  s.email       = ["thehiddendepth@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/aidi"
  s.summary     = ""
  s.description = ""

  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency             "connection_pool"
  s.add_dependency             "faraday"
  s.add_development_dependency "bundler"

  # s.files        = `git ls-files`.split("\n")
  s.files = Dir["{lib,vendor}/**/*"] + ["LICENSE", "README.md"]
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end
