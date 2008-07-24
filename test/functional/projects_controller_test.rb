require File.dirname(__FILE__) + '/../test_helper'
require 'projects_controller'

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < Test::Unit::TestCase

  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:projects)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_project
    assert_difference('Project.count', 1) do
      create_project()
    end
    
    assert_redirected_to project_members_path
  end
  
  def test_xml_should_create_project
    assert_difference('Project.count', 1) do
      create_project_xml()
    end
    assert_response :created
    assert_select "project:root>name", 'New Project'
  end
  
  def test_xml_create_needs_name
    assert_no_difference('Project.count') do
      create_project_xml(:name => nil)
    end
    assert_response :ok
    assert_select "errors:root>error", "Name can't be blank"
  end
  
  def test_xml_non_developer_cannot_create
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('Project.count') do
      create_project_xml()
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]    
  end

  def test_should_show_project
    get :show, :id => 1
    assert_response :success
  end

  def test_xml_should_have_work_units_real
    get :show, :format=>'xml', :id => 1
    assert_response :success
    assert_select "work_units_real", "3.0"
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_xml_should_update_project
    put :update, :id => 1, :format => 'xml', :project => {:name => 'Updated Name' }
    #assert_redirected_to project_path(assigns(:project))
    assert_response :success
    p = Project.find 1
    assert_equal 'Updated Name', p.name
  end
  
  def test_xml_non_developer_should_not_update_project
    @request.session[:user]=users(:aaron) #customer
    put :update, :id => 1, :format => 'xml', :project => {:name => 'Updated Name'}
    assert_response :success
    assert_select "errors:root>error", ERRORS[:not_authorized]
    p = Project.find 1
    assert_not_equal p.name, 'Updated Name'
  end
  
  # project can be deleted if it is not connected with foreign keys
  def test_should_destroy_lonely_project
    assert_difference("Project.count", -1) do 
      delete :destroy, :id => 3
    end
    assert_redirected_to current_iterations_path
  end
  
  def test_xml_non_developer_should_not_destroy
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference("Project.count") do 
      delete :destroy, :id => 3, :format => 'xml'
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end  
  
  # project cannot be deleted if it is connected with foreign keys
  def test_xml_should_not_destroy_project_with_fk
    assert_no_difference('Project.count') do
      delete :destroy, :id  => 1, :format => 'xml'
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:foreign_key_problem]
  end
  

  
  
  protected

    def create_project(options = {})
      post :create, :project => {
        :parent_id => 1, #child of tuskit project
        :tracker_id => 1, #tuskit
        :name => "New Project",
        :description => "Project for testing",
        :start_date => 0.days.ago
       }.merge(options)
    end

    def create_project_xml(options = {})
      post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<project>
  <parent_id>1</parent_id>
  <tracker_id>1</tracker_id>
  <name>New Project</name>
  <description>Project for testing</description>
  <start_date>#{0.days.ago}</start_date>
</project>"
      project, project_data = xml_to_params(post_xml,options)
      post :create, :format => "xml", project => project_data
    end

  
end
