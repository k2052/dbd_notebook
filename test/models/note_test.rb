require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class NoteControllerTest < Test::Unit::TestCase
  context "Note Model" do
    should 'construct new instance' do
      @note = Note.new
      assert_not_nil @note
    end
  end
end
