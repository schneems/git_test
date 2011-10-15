require 'spec_helper'

describe GitTest::Runner do
  let(:test) do
    mock :test,
         :created_at => Time.now,
         :result     => 'passed',
         :format     => 'html',
         :report     => '<h2>oh hai</h2>'
  end



  before(:each) do
    @runner = GitTest::Runner.new(:path => '.')
    @runner.stub(:test).and_return(test)
  end

  before do
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
  end

  describe 'test!' do
    it 'runs test' do
      @runner.test.should_receive(:run!)
      @runner.test!
    end
  end

  describe 'writer!' do
    it 'writes reports' do
      FakeFS do
        @runner.proj.should_receive(:username).and_return("schneems") # fakefs thwards the real call
        @runner.write_report!
      end
    end
  end
end
