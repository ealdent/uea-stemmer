# frozen_string_literal: true

version = File.read(File.expand_path("VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name = "uea-stemmer"
  spec.version = version
  spec.authors = ["Marie-Claire Jenkins", "Dan J. Smith", "Richard Churchill", "Jason Adams"]
  spec.email = ["jasonmadams@gmail.com"]

  summary = "Conservative UEA-Lite stemming for search and indexing."
  spec.summary = summary
  spec.description = "Ruby port of the UEA-Lite stemmer, designed to normalize common English suffixes without aggressive stemming."
  spec.homepage = "https://github.com/ealdent/uea-stemmer"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir.glob("lib/**/*").select { |path| File.file?(path) } +
    %w[LICENSE README.rdoc VERSION]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/ealdent/uea-stemmer/issues",
    "changelog_uri" => "https://github.com/ealdent/uea-stemmer/releases",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => spec.homepage
  }
end
