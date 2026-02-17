# frozen_string_literal: true

version = File.read(File.expand_path("VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name = "uea-stemmer"
  spec.version = version
  spec.authors = ["Marie-Claire Jenkins", "Dan J. Smith", "Richard Churchill", "Jason Adams"]
  spec.email = ["jasonmadams@gmail.com"]

  summary = "Port of UEA-Lite Stemmer to Ruby, a conservative stemmer for search and indexing."
  spec.summary = summary
  spec.description = summary
  spec.homepage = "https://github.com/ealdent/uea-stemmer"
  spec.license = "Apache-2.0"

  spec.files = Dir.glob("lib/**/*").select { |path| File.file?(path) } +
    Dir.glob("test/**/*").select { |path| File.file?(path) } +
    %w[.document LICENSE README.rdoc Rakefile VERSION uea-stemmer.gemspec]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/ealdent/uea-stemmer/issues",
    "changelog_uri" => "https://github.com/ealdent/uea-stemmer/releases",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  spec.add_development_dependency "rake", ">= 13.0", "< 14.0"
  spec.add_development_dependency "shoulda-context", ">= 2.0", "< 3.0"
  spec.add_development_dependency "test-unit", ">= 3.7", "< 4.0"
end
