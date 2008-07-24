require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < Test::Unit::TestCase

  def test_should_create
    new_project = nil
    assert_difference('Project.count', 1) do
      new_project = create_project()
    end
    assert_equal new_project.name, "New Project"
    assert_equal new_project.tracker, trackers(:tuskit)
    assert_equal new_project.parent, Project.find(1)
  end
    
  def test_create_requires_name
    p = nil
    assert_no_difference('Project.count') do
      p = create_project(:name => nil)
    end
    assert p.errors.on(:name)
  end
  
  def test_has_project_members_and_users
    p = projects(:tuskit)
    assert_not_nil p.project_members
    assert_not_nil p.users
    assert p.users.length > 1
    assert_equal p.users.length, p.project_members.length
  end
  
  def test_has_iterations
    p = projects(:tuskit)
    assert_not_nil p.iterations
    assert p.iterations.length > 0
    assert_equal p.iterations[0].class.to_s, 'Iteration'
  end
  
  def test_has_stories
    p = projects(:tuskit)
    assert_not_nil p.stories
    assert p.stories.length > 0
    assert_equal p.stories[1].class.to_s, 'Story'
  end
  
    def test_has_project_tasks
    p = projects(:tuskit)
    assert_not_nil p.project_tasks
    assert p.project_tasks.length > 0
    assert_equal p.project_tasks[0].class.to_s, 'ProjectTask'
  end

  def test_has_work_units_real
    p = projects(:tuskit)
    assert_not_nil p.work_units_real
    assert_equal p.work_units_real.class.to_s, 'Float'
  end
  
  def test_has_current_iteration
    p1 = projects(:tuskit)
    p2 = projects(:lonely_project)
    
    assert_not_nil p1.current_iteration
    assert_equal p1.current_iteration.class.to_s, 'Iteration' 
    
    assert_nil p2.current_iteration
  end

  protected

  def create_project(options = {})
    Project.create({
      :parent_id => 1, #child of tuskit project
      :tracker_id => 1, #tuskit
      :name => "New Project",
      :description => "Project for testing",
      :start_date => 0.days.ago
      }.merge(options))
  end

end
