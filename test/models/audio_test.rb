require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class AudioControllerTest < Test::Unit::TestCase
  context "Audio Model" do
    should 'construct new instance' do
      @audio = Audio.new
      assert_not_nil @audio
    end
  end
end
