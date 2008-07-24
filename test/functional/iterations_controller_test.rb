require File.dirname(__FILE__) + '/../test_helper'
require 'iterations_controller'

# Re-raise errors caught by the controller.
class IterationsController; def rescue_action(e) raise e end; end

class IterationsControllerTest < Test::Unit::TestCase
  fixtures :iterations

  def setup
    @controller = IterationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:iterations)
  end
  
  def test_xml_should_get_index
    get :index, :format => 'xml', :project_id => 1  
    assert_response :success
    assert_select 'iterations:root', 1
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_iteration
    assert_difference('Iteration.count') do
      post :create, :iteration => {:project_id => 2 }
    end

    assert_redirected_to iteration_path(assigns(:iteration))
  end
  
  def test_xml_non_developer_should_not_create
    @request.session[:user]=users(:aaron) #developer
    assert_no_difference('Iteration.count') do
      create_xml
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end
    
  def test_should_show_iteration
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_iteration
    put :update, :id => 1, :iteration => { }
    assert_redirected_to iteration_path(assigns(:iteration))
  end
  
  def test_xml_non_developer_should_not_update_iteration
    @request.session[:user]=users(:aaron) #developer
    put :update, :format => 'xml', :id => 1, :iteration => { :name => 'New Name' }
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
    i = Iteration.find 1
    assert_not_equal i.name, 'New Name'
  end

  def test_should_destroy_iteration
    assert_difference('Iteration.count', -1) do
      delete :destroy, :id => 2
    end

    assert_redirected_to iterations_path
  end
  
  def test_non_developer_should_not_destroy
    @request.session[:user]=users(:aaron) #developer
    assert_no_difference('Iteration.count') do
      delete :destroy, :id => 2
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_auhtorized]
  end
  
  def test_xml_should_not_destroy_iteration_with_fk
    assert_no_difference('Iteration.count') do
      delete :destroy, :id => 1
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:foreign_key_problem]
  end
  
  protected

  def create_xml(options = {})
    post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<iteration>
<project_id>2</project_id>
<name>Testing</name>
<objectives>Iteration for testing</objectives>
<work_units>20.5</work_units>
<start_date>#{0.days.ago}</start_date>
</iteration>"
    inst, inst_data = xml_to_params(post_xml,options)
    post :create, :format => "xml", inst => inst_data
  end
  
end
