require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class QuoteControllerTest < Test::Unit::TestCase
  context "Quote Model" do
    should 'construct new instance' do
      @quote = Quote.new
      assert_not_nil @quote
    end
  end
end
