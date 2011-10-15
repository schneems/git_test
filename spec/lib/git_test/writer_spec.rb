require 'spec_helper'
require 'fakefs/safe'


describe GitTest::Writer do
  before do
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
  end

  describe 'an instance' do
    before(:each) do
      @path   = "/whatever/foo"
      @report = "<h2>Hello</h2>"
      @name   = "kitty_cats.html"
      @writer = GitTest::Writer.new(:path => @path, :report => @report, :name => @name)
    end

    it 'makes a directory' do
      @writer.mkdir!
      File.directory?(@path).should be_true
    end

    it 'builds a correct path'do
      @writer.full_path.should eq("#{@path}/#{@name}")
    end

    it 'writes to specified directory' do
      @writer.save!
      File.exists?(@writer.full_path).should be_true
    end

    it 'saves the report' do
      @writer.report.should eq(@report)
    end

  end
end
