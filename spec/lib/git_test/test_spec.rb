require 'spec_helper'

describe GitTest do
  before(:each) do
  end

  describe 'passing tests' do
    before(:each) do
      @test = GitTest::Test.new(:cmd => "rspec ./fake_spec/pass_lib -f h -c")
    end

    it 'runs tests' do
      @test.run!
      @test.status.should     eq("passed")
      @test.passed?.should    be_true
      @test.failed?.should    be_false
      @test.exit_code.should  eq(0)
    end
  end
end
