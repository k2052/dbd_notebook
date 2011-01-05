require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class DefaultControllerTest < Test::Unit::TestCase
  context "Default Model" do
    should 'construct new instance' do
      @default = Default.new
      assert_not_nil @default
    end
  end
end
