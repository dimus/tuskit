require File.dirname(__FILE__) + '/../test_helper'
require 'project_members_controller'

# Re-raise errors caught by the controller.
class ProjectMembersController; def rescue_action(e) raise e end; end

class ProjectMembersControllerTest < Test::Unit::TestCase
  fixtures :project_members

  def setup
    @controller = ProjectMembersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index, :project_id => 1
    assert_response :success
    assert assigns(:project_members)
  end
  
  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_project_member
    assert_difference('ProjectMember.count') do
      create_project_member()
    end
    assert_redirected_to project_project_members_path(assigns(:project))
  end
  
  def test_xml_non_developer_cannot_create
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('ProjectMember.count') do
      create_project_member_xml()
    end
    assert_response :success
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end

  def test_should_show_project_member
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_project_member
    put :update, :id => 1, :project_member => { :active => false }
    assert_redirected_to project_project_members_path(1)
  end
  
  def test_non_developer_cannot_update
    @request.session[:user]=users(:aaron) #customer
    put :update, :id => 1, :format => 'xml', :project_member => { :active => false }
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end
    

  def test_should_destroy_project_member
    assert_equal(ProjectMember.find(1).active,true)
    delete :destroy, :id => 1
    assert_redirected_to project_members_path
    assert_equal(ProjectMember.find(1).active,false)
  end
  
  def test_xml_non_developer_cannot_destroy
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('ProjectMember.count') do
      delete :destroy, :id => 1, :format => 'xml'
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end
  
  protected
  def create_project_member(options = {})
    post :create, {:project_members => {
      :project_id => 1}, 
      :users => [3]}.merge(options)
  end
  
  def create_project_member_xml(options = {})
    post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<project_member>
<project_id>1</project_id>
<user_id>1</user_id>
</project_member>"
    project_member, project_member_data = xml_to_params(post_xml,options)
    post :create, :format => "xml", project_member => project_member_data
  end
  
end
