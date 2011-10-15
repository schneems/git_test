# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','git_test_version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'git_test'
  s.version = GitTest::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
bin/git_test
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','git_test.rdoc']
  s.rdoc_options << '--title' << 'git_test' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'git_test'

  # Development Dependencies
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('rb-fsevent')
  s.add_development_dependency('fakefs')
  s.add_development_dependency('gli')

  ## Runtime Dependencies
  s.add_runtime_dependency('git')
  s.add_runtime_dependency('gli')
  s.add_runtime_dependency('colorize')
  s.add_runtime_dependency('growl')

end
