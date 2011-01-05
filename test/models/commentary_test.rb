require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class CommentaryControllerTest < Test::Unit::TestCase
  context "Commentary Model" do
    should 'construct new instance' do
      @commentary = Commentary.new
      assert_not_nil @commentary
    end
  end
end
