require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class TaskControllerTest < Test::Unit::TestCase
  context "Task Model" do
    should 'construct new instance' do
      @task = Task.new
      assert_not_nil @task
    end
  end
end
