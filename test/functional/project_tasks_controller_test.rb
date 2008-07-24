require File.dirname(__FILE__) + '/../test_helper'
require 'project_tasks_controller'

# Re-raise errors caught by the controller.
class ProjectTasksController; def rescue_action(e) raise e end; end

class ProjectTasksControllerTest < Test::Unit::TestCase

  def setup
    @controller = ProjectTasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:project_tasks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_task
    assert_difference('ProjectTask.count') do
      post :create, :project_task => {:project_id => 1, :name => 'New Name'}
    end

    assert_redirected_to project_task_path(assigns(:project_task))
  end
  
  def test_xml_should_create
    assert_difference('ProjectTask.count') do
      create_xml
    end
    assert_response :created
    assert_select "project_task:root>name", "New Task"
  end

  def test_xml_non_developer_cannot_create
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('ProjectTask.count') do
      create_xml
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end

  def test_should_show_task
    get :show, :id => 2
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 2
    assert_response :success
  end

  def test_should_update_task
    put :update, :id => 2, :project_task => { }
    assert_redirected_to project_task_path(assigns(:project_task))
  end
  
  def test_xml_should_update_task
    put :update, :id => 2, :format => 'xml', :project_task => { :name => 'New Name' }
    assert_response :ok
    t = ProjectTask.find 2
    assert_equal t.name, 'New Name'
  end

  def test_xml_non_developer_cannot_update
    @request.session[:user]=users(:aaron) #customer
    put :update, :id => 2, :format => 'xml', :project_task => { :name => 'New Name' }
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
    t = ProjectTask.find 2
    assert_not_equal t.name, 'New Name'
  end

  def test_should_destroy_task
    assert_difference('ProjectTask.count', -1) do
      delete :destroy, :id => 2
    end

    assert_redirected_to project_tasks_path
  end
  
  def test_xml_non_user_cannot_destroy
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('ProjectTask.count') do
      delete :destroy, :format => 'xml', :id => 2
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end
  
  protected

  def create_xml(options = {})
    post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<project_task>
  <project_id>1</project_id>
  <tracker_ticket_id>22</tracker_ticket_id> 
  <tracker_ticket_submitter>dimus</tracker_ticket_submitter>
  <name>New Task</name>
  <notes>Testing Task</notes>
  <bug>false</bug>
  <created_by>system</created_by>
  <updated_by>system</updated_by>
  <created_at>2007-07-15 23:35:03</created_at>
  <updated_at>2007-07-15 23:35:03</updated_at>
</project_task>"
    inst, inst_data = xml_to_params(post_xml,options)
    post :create, :format => "xml", inst => inst_data
  end

end
