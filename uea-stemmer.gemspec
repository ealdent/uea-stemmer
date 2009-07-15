# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{uea-stemmer}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Adams"]
  s.date = %q{2009-07-15}
  s.description = %q{Port of UEA-Lite Stemmer to Ruby, a conservative stemmer for search and indexing.}
  s.email = %q{jasonmadams@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/rule.rb",
     "lib/string_extensions.rb",
     "lib/uea-stemmer.rb",
     "lib/word.rb",
     "test/test_helper.rb",
     "test/uea_stemmer_test.rb",
     "uea-stemmer.gemspec"
  ]
  s.homepage = %q{http://github.com/ealdent/uea-stemmer}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Port of UEA-Lite Stemmer to Ruby, a conservative stemmer for search and indexing.}
  s.test_files = [
    "test/test_helper.rb",
     "test/uea_stemmer_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
