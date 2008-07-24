require File.dirname(__FILE__) + '/../test_helper'
require 'meeting_participants_controller'

# Re-raise errors caught by the controller.
class MeetingParticipantsController; def rescue_action(e) raise e end; end

class MeetingParticipantsControllerTest < Test::Unit::TestCase
  fixtures :meeting_participants

  def setup
    @controller = MeetingParticipantsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:meeting_participants)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_meeting_participant
    assert_difference('MeetingParticipant.count') do
      post :create, :meeting_participant => {:meeting_id => 2, :user_id => 1 }
    end

    assert_redirected_to meeting_participant_path(assigns(:meeting_participant))
  end
  
  def test_xml_create
    mp = nil
    assert_difference('MeetingParticipant.count', 1) do
      create_xml
    end
    assert_select "meeting_participant:root>user_id", '3'
  end
  
  def test_xml_non_developer_cannot_create
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('MeetingParticipant.count') do
      create_xml
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end

  def test_should_show_meeting_participant
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_meeting_participant
    put :update, :id => 1, :meeting_participant => { :user_id  => 3 }
    assert_redirected_to meeting_participant_path(assigns(:meeting_participant))
    mp = MeetingParticipant.find 1
    assert_equal mp.user_id, 3
  end
  
  def test_xml_non_developer_cannot_update
    @request.session[:user]=users(:aaron) #customer
    put :update, :id => 1, :format => 'xml', :meeting_participant => { :user_id => 3}
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
    mp = MeetingParticipant.find 1
    assert_not_equal mp.user_id, 3
  end

  def test_should_destroy_meeting_participant
    assert_difference('MeetingParticipant.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to meeting_participants_path
  end
  
  def test_xml_non_developer_cannot_destroy
    @request.session[:user]=users(:aaron) #customer
    assert_no_difference('MeetingParticipant.count') do
      delete :destroy, :format => 'xml', :id => 1
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:not_authorized]
  end
  
  protected

  def create_xml(options = {})
    post_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<meeting_participant>
<meeting_id>1</meeting_id>
<user_id>3</user_id>
</meeting_participant>"
    indx, indx_data = xml_to_params(post_xml,options)
    post :create, :format => "xml", indx => indx_data
  end

end
