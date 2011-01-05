require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class CodesControllerTest < Test::Unit::TestCase
  context "CodesController" do
    setup do
      get '/'
    end

    should "return hello world text" do
      assert_equal "Hello World", last_response.body
    end
  end
end
