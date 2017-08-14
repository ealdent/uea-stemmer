require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "uea-stemmer"
    gem.summary = %Q{Port of UEA-Lite Stemmer to Ruby, a conservative stemmer for search and indexing.}
    gem.description = %Q{Port of UEA-Lite Stemmer to Ruby, a conservative stemmer for search and indexing.}
    gem.email = "jasonmadams@gmail.com"
    gem.homepage = "http://github.com/ealdent/uea-stemmer"
    gem.authors = ["Marie-Claire Jenkins", "Dan J. Smith", "Richard Churchill", "Jason Adams"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test
