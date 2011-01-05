require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class ThingControllerTest < Test::Unit::TestCase
  context "Thing Model" do
    should 'construct new instance' do
      @thing = Thing.new
      assert_not_nil @thing
    end
  end
end
