source 'https://rubygems.org'

group :development do
  # jeweler is incompatible with oauth2 2.x and rack 3.x
  # It's optional - Rakefile has a rescue clause for LoadError
  # gem 'jeweler'
  
  gem 'test-unit'
  gem 'shoulda'
  gem 'rake'
  gem 'awesome_print'
  
  # Explicitly require newer versions to get rack 3.x
  gem 'oauth2', '>= 2.0'
  gem 'rack', '>= 3.0'
end
