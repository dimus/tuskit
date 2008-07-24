require File.dirname(__FILE__) + '/../test_helper'

class IterationTest < Test::Unit::TestCase

  def test_should_create
    assert_difference('Iteration.count',1) do
      create
    end
  end
  
  def test_belongs_to_project
    i = Iteration.find 1
    assert_not_nil i.project
    assert_equal i.project.class.to_s, 'Project'
  end
  
  def test_has_meetings
    i = iterations(:admin_view)
    assert_not_nil i.meetings
    assert_equal i.meetings[0].class.to_s, 'Meeting'
  end
  
  def test_has_stories
    i = iterations(:admin_view)
    assert_not_nil i.stories
    assert_equal i.stories[0].class.to_s, 'Story'
  end
  
  def test_has_agile_tasks
    i = iterations(:admin_view)
    assert_not_nil i.agile_tasks
    assert_equal i.agile_tasks[0].class.to_s, 'AgileTask'
  end
  
  def test_has_agile_tasks_number
    i=iterations(:admin_view)
    assert_not_nil i.agile_tasks_number
    assert i.agile_tasks_number > 1
  end

  protected

  def create(options = {})
    Iteration.create({
      :project_id => 2,
      :name => "New Iteration",
      :objectives => "To Test Iteration",
      :start_date  => 0.days.ago,
      :work_units => 30.5
      }.merge(options))
  end
  
end
