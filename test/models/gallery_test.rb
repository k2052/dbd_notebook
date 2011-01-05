require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class GalleryControllerTest < Test::Unit::TestCase
  context "Gallery Model" do
    should 'construct new instance' do
      @gallery = Gallery.new
      assert_not_nil @gallery
    end
  end
end
