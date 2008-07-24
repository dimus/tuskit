require File.dirname(__FILE__) + '/../test_helper'

class ProjectMemberTest < Test::Unit::TestCase

  def test_belongs_to_user_project
    pm = project_members(:quentin_tuskit)
    assert_not_nil pm.project
    assert_not_nil pm.user
    assert_equal pm.project.class.to_s, 'Project'
    assert_equal pm.user.class.to_s, 'User'
  end
  
  def test_create
    pm = nil
    assert_difference('ProjectMember.count', 1) do
      pm = create_project_member()
    end
    assert_equal pm.user.first_name, 'John'
  end
  
  def test_do_not_create_duplicate_records
    pm = nil
    assert_no_difference('ProjectMember.count') do
      pm = create_project_member(:user_id =>1)
    end
    assert_not_nil pm.errors.on(:user_id)
  end
  
  def test_create_needs_user_id
    pm = nil
    assert_no_difference('ProjectMember.count') do
      pm = create_project_member(:user_id => nil)
    end
    assert_not_nil pm.errors.on(:user_id)
  end
  
  def test_create_needs_project_id
    pm = nil
    assert_no_difference('ProjectMember.count') do
      pm = create_project_member(:project_id => nil)
    end
    assert_not_nil pm.errors.on(:project_id)
  end
  
  protected
  def create_project_member(options = {})
    ProjectMember.create({
      :project_id => 1,
      :user_id => 3, 
      }.merge(options))
  end
  
end
