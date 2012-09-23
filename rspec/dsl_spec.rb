require "rspec"
require_relative "../dsl.rb"


describe specify do

  it "should return parameter" do

    specify { "something" } do
      "say hello"
    end

  end
end


=begin
describe Test do

  it "should greet" do

    @test = Test.new
    @test.greet.should_not be_empty

  end
end
=end

