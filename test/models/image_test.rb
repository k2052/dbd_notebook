require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class ImageControllerTest < Test::Unit::TestCase
  context "Image Model" do
    should 'construct new instance' do
      @image = Image.new
      assert_not_nil @image
    end
  end
end
