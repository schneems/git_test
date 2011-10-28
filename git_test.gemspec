# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','git_test_version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'git_test'
  s.version = GitTest::VERSION
  s.author = 'Richard Schneeman'
  s.email = 'richard.schneeman@gmail.com'
  s.homepage = 'https://github.com/schneems/git_test'
  s.platform = Gem::Platform::RUBY
  s.summary = "git_test runs your tests and stores them in git. Use git_test to track
    tests over multiple branches, runs, and teammates. Run git_test when you pull and push
    and you'll always know the state of your project!"
# Add your other files here if you make them
  s.files = %w(
    lib/git_test.rb
    lib/git_test/notify.rb
    lib/git_test/proj.rb
    lib/git_test/runner.rb
    lib/git_test/test.rb
    lib/git_test/writer.rb
    lib/git_test_version.rb
    bin/git_test
  )
  s.require_paths << 'lib'
  s.extra_rdoc_files = [
    "README.md"
  ]
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
  s.add_runtime_dependency('gli', '1.3.5')
  s.add_runtime_dependency('colorize')
  s.add_runtime_dependency('growl')

end
