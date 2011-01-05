require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class CommentControllerTest < Test::Unit::TestCase
  context "Comment Model" do
    should 'construct new instance' do
      @comment = Comment.new
      assert_not_nil @comment
    end
  end
end
