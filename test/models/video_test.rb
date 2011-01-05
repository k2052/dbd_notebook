require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class VideoControllerTest < Test::Unit::TestCase
  context "Video Model" do
    should 'construct new instance' do
      @video = Video.new
      assert_not_nil @video
    end
  end
end
