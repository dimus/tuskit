require File.dirname(__FILE__) + '/../test_helper'
require 'groups_controller'

# Re-raise errors caught by the controller.
class GroupsController; def rescue_action(e) raise e end; end

class GroupsControllerTest < Test::Unit::TestCase
  fixtures :groups, :memberships, :users

  def setup
    @controller = GroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:aaron)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:groups)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_group
    old_count = Group.count
    create_group
    assert_equal old_count+1, Group.count
    
    assert_redirected_to group_path(assigns(:group))
  end

  def test_should_show_group
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_group
    put :update, :id => 1, :group => { }
    assert_redirected_to group_path(assigns(:group))
  end
  
  def test_should_destroy_group
    old_count = Group.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Group.count
    
    assert_redirected_to groups_path
  end
  private
    def create_group(options = {})
      post :create, :group => { :name => 'god', :created_by => 'test', :updated_by => 'test' }.merge(options)
    end
end
