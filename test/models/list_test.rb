require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class ListControllerTest < Test::Unit::TestCase
  context "List Model" do
    should 'construct new instance' do
      @list = List.new
      assert_not_nil @list
    end
  end
end
