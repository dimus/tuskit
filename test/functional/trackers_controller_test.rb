require File.dirname(__FILE__) + '/../test_helper'
require 'trackers_controller'

# Re-raise errors caught by the controller.
class TrackersController; def rescue_action(e) raise e end; end

class TrackersControllerTest < Test::Unit::TestCase

  def setup
    @controller = TrackersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:john) #developer
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:trackers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_tracker
    old_count = Tracker.count
      create_tracker
    assert_equal old_count+1, Tracker.count
    
    assert_redirected_to tracker_path(assigns(:tracker))
  end
  
  def test_non_developer_cannot_create_tracker
    @request.session[:user] = users(:aaron) #customer
    assert_no_difference('Tracker.count') do
      create_tracker_xml
    end
    assert_response :success
    assert_select 'errors:root>error', ERRORS[:not_authorized]
  end
  
  def test_should_show_tracker
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_tracker
    put :update, :id => 1, :tracker => {:name => 'new_name'}
    assert_redirected_to tracker_path(assigns(:tracker))
    t = Tracker.find 1
    assert_equal t.name, 'new_name'
  end

  def test_xml_should_update_tracker
    put :update, :id => 1, :format => 'xml', :tracker => {:name => 'new_name'}
    assert_response :success
    assert @response.body.strip == ''
    t = Tracker.find 1
    assert_equal t.name, 'new_name'
  end
  
  def test_xml_non_developer_should_not_update_tracker
    @request.session[:user] = users(:aaron) #customer
    put :update, :id => 1, :format => 'xml', :tracker => {:name => 'new_name'}
    assert_response :success
    assert_select "errors:root>error", ERRORS[:not_authorized]
    t = Tracker.find 1
    assert_not_equal t.name, 'new_name'
  end
  
  def test_should_destroy_tracker
    assert_difference('Tracker.count', -1) do
    delete :destroy, :id => 2
    end  
    assert_redirected_to trackers_path
  end
  
  def test_xml_should_destroy_tracker
    assert_difference('Tracker.count', -1) {
      delete :destroy, :id => 2, :format => 'xml'
    }
    assert_response :success
    assert_equal @response.body.strip, ''
  end
  
  def test_xml_non_developer_should_not_destroy_tracker
    @request.session[:user] = users(:aaron) #customer
    assert_no_difference('Tracker.count') {
      delete :destroy, :id => 2, :format => 'xml'
    }
    assert_response :success
    assert_select 'errors:root>error', ERRORS[:not_authorized]
  end  
  
  def test_should_not_destroy_tracker_with_fk
    assert_no_difference("Tracker.count") { delete :destroy, :id => 1 }    
  end
  
  def test_xml_should_not_destroy_tracker_with_fk
    assert_no_difference('Tracker.count') do 
      delete :destroy, :id  => 1, :format => 'xml'
    end
    assert_response :success
    assert_select "errors:root>error", ERRORS[:delete_foreign_key_problem]
  end
  
  protected
  
    def create_tracker(options = {})
      post :create, :tracker => {
        :application => "Trac",
         :name => "GTDelux",
         :uri => "http://remote_user:secret@gtdelux.com/trac",
      }.merge(options)
    end

    def create_tracker_xml(options = {})
      post_xml = '
<?xml version="1.0" encoding="UTF-8" ?>
<tracker>
  <application>Trac</application>
  <name>GTDelux</name>
  <uri>http://remote_user:secret@gtdelux.com/trac</uri>
</tracker>'   
      tracker, tracker_data = xml_to_params(post_xml,options)
      post :create, :format => "xml", tracker => tracker_data
    end
    
    
end
