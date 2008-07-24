require File.dirname(__FILE__) + '/../test_helper'
require 'meetings_controller'

# Re-raise errors caught by the controller.
class MeetingsController; def rescue_action(e) raise e end; end

class MeetingsControllerTest < Test::Unit::TestCase

  def setup
    @controller = MeetingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:meetings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_meeting
    assert_difference('Meeting.count') do
      post :create, :meeting => {:iteration_id => 1 }
    end

    assert_redirected_to meeting_path(assigns(:meeting))
  end
  
  def test_xml_non_developer_should_not_create
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('Meeting.count') do
      create_xml
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end

  def test_should_show_meeting
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_meeting
    put :update, :id => 1, :meeting => { :name => 'New Name' }
    assert_redirected_to meeting_path(assigns(:meeting))
    m = Meeting.find 1
    assert m.name == 'New Name'
  end
  
  def test_xml_non_developer_should_not_update
    @request.session[:user]=users(:aaron) #customer
    put :update, :id => 1, :format => 'xml', :meeting => { :name => 'New Name' }
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
    m = Meeting.find 1
    assert_not_equal m.name, 'New Name'
  end

  def test_should_destroy_lonely_meeting
    assert_difference('Meeting.count', -1) do
      delete :destroy, :id => 2
    end

    assert_redirected_to meetings_path
  end
  
  def test_should_not_destroy_meeting_with_fk
    assert_no_difference('Meeting.count') do
      delete :destroy, :id => 1
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:foreign_key_problem]
  end

  protected

  def create_xml(options = {})
    post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<meeting>
<iteration_id>1</iteration_id>
<meeting_date>2007-07-02</meeting_date>
<notes>test meeting</notes>
<length>20.5</length>
<name>test</name>
<notes>testing meetings</notes>
</meeting>"
    inst, inst_data = xml_to_params(post_xml,options)
    post :create, :format => "xml", inst => inst_data
  end


end
