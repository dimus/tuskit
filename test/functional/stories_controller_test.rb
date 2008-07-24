require File.dirname(__FILE__) + '/../test_helper'
require 'stories_controller'

# Re-raise errors caught by the controller.
class StoriesController; def rescue_action(e) raise e end; end

class StoriesControllerTest < Test::Unit::TestCase
  fixtures :stories

  def setup
    @controller = StoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:stories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_story
    assert_difference('Story.count') do
      post :create, :story => { :iteration_id => 2, :name => "A story" }
    end

    assert_redirected_to story_path(assigns(:story))
  end

  def test_xml_should_create_story
    assert_difference('Story.count') do
      create_xml
    end
    assert_response :created
    assert_select "story:root>iteration_id", 1
  end
  
  def test_xml_non_developer_cannot_create
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('Story.count') do
      create_xml
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]  
  end
  
  def test_should_show_story
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_story
    put :update, :id => 1, :story => { }
    assert_redirected_to story_path(assigns(:story))
  end
  
  def test_xml_non_developer_cannot_update
    @request.session[:user]=users(:aaron) #customer
    put :update, :id => 1, :format => 'xml', :story => { :name => 'New Name' }
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
    s = Story.find 1
    assert_not_equal s.name, 'New Name'
  end

  def test_should_destroy_story
    assert_difference('Story.count', -1) do
      delete :destroy, :id => 3
    end

    assert_redirected_to stories_path
  end
  
  def test_xml_non_developer_cannot_destroy
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('Story.count') do
      delete :destroy, :format => 'xml', :id => 3
    end
    
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end
  
  def test_xml_cannot_destroy_with_fk
    assert_no_difference('Story.count') do
      delete :destroy, :format => 'xml', :id => 1
    end
    
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:foreign_key_problem]
  end
  
  protected

  def create_xml(options = {})
    post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<story>
  <iteration_id>1</iteration_id>
  <name>New Story</name>
  <description>Story for testing</description>
  <work_units_est>3.5</work_units_est>
  <completed>false</completed>
</story>"
    inst, inst_data = xml_to_params(post_xml,options)
    post :create, :format => "xml", inst => inst_data
  end


end
