require 'spec_helper'

describe GitTest do
  before(:each) do
    @out    = STDOUT
    @notify = GitTest::Notify.new(@out)
  end

  describe 'output' do
    it 'start' do
      @notify.start("foo")
    end
  end
end



