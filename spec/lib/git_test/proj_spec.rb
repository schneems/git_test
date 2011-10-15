require 'spec_helper'

describe GitTest::Proj do
  before(:each) do
    @proj = GitTest::Proj.new(:path => '.')
  end

  it 'is an extension of GitBase' do
    @proj.is_a?(Git::Base).should eq(true)
  end

  it 'produces a username' do
    @proj.username
  end

  it 'produces a path' do
    @proj.path
  end

  it 'clones directories' do
    pending 'fakefs doesnt seem to work with git commands'
    FakeFS do
      path = 'foo'
      FileUtils.mkdir_p(path)
      @proj.clone_to(path)
      Dir.chdir(path) {puts system 'ls'}
    end
  end

end
