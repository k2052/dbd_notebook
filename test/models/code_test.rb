require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class CodeControllerTest < Test::Unit::TestCase
  context "Code Model" do
    should 'construct new instance' do
      @code = Code.new
      assert_not_nil @code
    end
  end
end
