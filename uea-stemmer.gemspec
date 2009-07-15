# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{uea-stemmer}
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Adams"]
  s.date = %q{2009-07-14}
  s.description = %q{Similar to other stemmers, UEA-Lite operates on a set of rules which are used as steps. There are two groups of rules: the first to clean the tokens, and the second to alter suffixes.

The first group of rules first avoids a small list of six frequent problem words. An improvement to the stemmer would be to expand this list by adding other problem words which the second rule set cannot deal with. Second, possessive apostrophes are removed and contractions are expanded. All hyphens are removed and tokens containing digits are left untouched. Strings which are all upper case and digits are left untouched unless there is a lower case terminal 's' (i.e. transforming plural forms of acronyms to singular forms).

Proper nouns should not usually be stemmed, except to remove possessives; our implementation will respect PoS tags if they are present. If the text is untagged the stemmer uses the simple heuristic that any capitalized token not preceded by sentence breaking punctuation is a proper noun.

Many texts, particularly scientific papers, contain sequences of digits, single letters, and other non-word tokens. Our implementation ignores tokens containing digits, single-letter tokens, and tokens with embedded punctuation.

The second group of rules contains 139 suffix rules, each testing for a specific type of suffix. The rules are set in a particular order so that the longest suffix applicable is used rather a shorter one which could lead to nonsense words and more words not stemmed entirely to their root form.}
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
     "test/uea_stemmer_test.rb"
  ]
  s.homepage = %q{http://github.com/ealdent/uea-stemmer}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Ruby port of the UEALite Stemmer}
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
