require File.dirname(__FILE__) + '/../test_helper'

class AgileTaskTest < Test::Unit::TestCase

  def test_belongs_to_story
    at = tasks(:agile_task1)
    assert_equal at.class.to_s, 'AgileTask'
    assert_not_nil at.story
    assert at.story.class.to_s == 'Story'
  end

  def test_belongs_to_iteration
    at = tasks(:agile_task1)
    assert_not_nil at.iteration
    assert at.iteration.class.to_s == 'Iteration'
  end
  
  def test_belongs_to_project
    at = tasks(:agile_task1)
    assert_not_nil at.project
    assert at.project.class.to_s == 'Project'
  end
  
  def test_belongs_to_tracker
    at = tasks(:agile_task1)
    assert_not_nil at.tracker
    assert at.tracker.class.to_s == 'Tracker'
  end
  
  def test_has_many_task_owners
    at = tasks(:agile_task1)
    assert_not_nil at.task_owners
    assert at.task_owners.length > 0
    assert_equal at.task_owners[0].class.to_s, 'TaskOwner'
  end
  
  
  def test_create_needs_story_id
    t = nil
    assert_no_difference('AgileTask.count') do
      t = create(:story_id => nil)
    end
    assert t.errors.on(:story_id)
  end


  protected

  def create(options = {})
    AgileTask.create({
      :story_id => 1,
      :name => "New Task",
      }.merge(options))
  end

  
end
