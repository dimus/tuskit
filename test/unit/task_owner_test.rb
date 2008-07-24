require File.dirname(__FILE__) + '/../test_helper'

class TaskOwnerTest < Test::Unit::TestCase

  def test_create
    assert_difference("TaskOwner.count", 1) do
      create
    end
  end
  
  def test_no_duplicates
    t = nil
    assert_no_difference("TaskOwner.count") do
      t = create :user_id => 1
    end
    assert_not_nil t.errors.on(:user_id)
  end
  
  def test_create_needs_user_id
    assert_no_difference('TaskOwner.count') do
      create :user_id => nil
    end
  end
  
  def test_create_needs_agile_task_id
    assert_no_difference('TaskOwner.count') do
      create :agile_task_id  => nil
    end
  end
  
  def test_belongs_to_agile_task
    t = task_owners(:one)
    assert_not_nil t.agile_task
    assert_equal t.agile_task.class.to_s, 'AgileTask'
  end
  

  protected
  def create(options = {})
    TaskOwner.create({
      :agile_task_id => 3,
      :user_id => 3, 
      }.merge(options))
  end

end
