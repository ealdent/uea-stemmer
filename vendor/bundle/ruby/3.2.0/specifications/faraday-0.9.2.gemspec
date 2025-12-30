# -*- encoding: utf-8 -*-
# stub: faraday 0.9.2 ruby lib

Gem::Specification.new do |s|
  s.name = "faraday".freeze
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Rick Olson".freeze]
  s.date = "2015-10-06"
  s.email = "technoweenie@gmail.com".freeze
  s.homepage = "https://github.com/lostisland/faraday".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "HTTP/REST API client library.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_runtime_dependency(%q<multipart-post>.freeze, [">= 1.2", "< 3"])
end
