require File.dirname(__FILE__) + '/../test_helper'

class ProjectTaskTest < Test::Unit::TestCase


  def test_belongs_to_project
    pt = tasks(:project_task1)
    assert_equal pt.class.to_s, 'ProjectTask'
    assert_not_nil pt.project
    assert pt.project.class.to_s == 'Project'
  end 
  
  def test_belongs_to_tracker
    pt = tasks(:project_task1)
    assert_not_nil pt.tracker
    assert pt.tracker.class.to_s == 'Tracker'
  end

  def test_create_needs_project_id
    t = nil
    assert_no_difference('ProjectTask.count') do
      t = create(:project_id => nil)
    end
    assert t.errors.on(:project_id)
  end


  protected

  def create(options = {})
    ProjectTask.create({
      :project_id => 1,
      :name => "New Task",
      }.merge(options))
  end


end
