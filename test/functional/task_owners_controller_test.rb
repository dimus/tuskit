require File.dirname(__FILE__) + '/../test_helper'
require 'task_owners_controller'

# Re-raise errors caught by the controller.
class TaskOwnersController; def rescue_action(e) raise e end; end

class TaskOwnersControllerTest < Test::Unit::TestCase
  fixtures :task_owners

  def setup
    @controller = TaskOwnersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:task_owners)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_task_owner
    assert_difference('TaskOwner.count') do
      post :create, :task_owner => { :user_id => 1, :agile_task_id => 4 }
    end

    assert_redirected_to task_owner_path(assigns(:task_owner))
  end
  
  def test_xml_should_create
    assert_difference('TaskOwner.count', 1) do
      create_xml
    end
    assert_response :created
    assert_select "task_owner:root>user_id", '3'
  end
  
  def test_xml_non_developer_cannot_create
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('TaskOwner.count') do
      create_xml
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end

  def test_should_show_task_owner
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_task_owner
    put :update, :id => 1, :task_owner => { }
    assert_redirected_to task_owner_path(assigns(:task_owner))
  end
  
  def test_xml_should_update
    put :update, :id => 1, :format => 'xml', :task_owner => { :agile_task_id => 4}
    assert_response :ok
    t = TaskOwner.find 1
    assert_equal t.agile_task_id, 4
  end
  
  def test_xml_non_developer_cannot_update
    @request.session[:user]=users(:aaron) #customer
    put :update, :id => 1, :format => 'xml', :task_owner => { :agile_task_id => 4}
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
    t = TaskOwner.find 1
    assert_not_equal t.agile_task_id, 4
  end
  

  def test_should_destroy_task_owner_with_fk
    assert_difference('TaskOwner.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to task_owners_path
  end
  
  def test_xml_non_developer_cannot_destroy
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('TaskOwner.count') do
      delete :destroy, :format => 'xml', :id => 1
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end
  
  protected

  def create_xml(options = {})
    post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<task_owner>
  <user_id>3</user_id>
  <agile_task_id>3</agile_task_id>
</task_owner>"
    inst, inst_data = xml_to_params(post_xml,options)
    post :create, :format => "xml", inst => inst_data
  end

  
end
