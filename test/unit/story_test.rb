require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < Test::Unit::TestCase
  fixtures :stories
  
  def test_create
    assert_difference('Story.count',1) do
      create
    end
  end
  
  def test_create_needs_name
    assert_no_difference('Story.count') do
      create :name => nil
    end
  end
  
  def test_belongs_to_iteration
    s = stories(:add_filters)
    assert_not_nil s.iteration
    assert s.iteration.class.to_s == 'Iteration'
  end
  
  def test_belongs_to_project
    s = stories(:add_filters)
    assert_not_nil s.project
    assert s.project.class.to_s == 'Project'
  end 

  def test_has_agile_tasks
    s = stories(:add_filters)
    assert_not_nil s.agile_tasks
    assert s.agile_tasks.length > 0
    assert_equal s.agile_tasks[0].class.to_s, 'AgileTask'
  end

  protected
  def create(options = {})
    Story.create({
      :iteration_id => 1, #child of tuskit project
      :name => "New Story",
      :description => "Story for testing",
      :work_units_est => 3.5,
      :completed => false
      }.merge(options))
  end

end
