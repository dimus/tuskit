require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'


# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_admin_should_get_index
    @request.session[:user]=users(:quentin) #admin
    get :index
    assert_response :success
    assert assigns(:users)
  end
  
  def test_no_admin_should_not_get_index
    @request.session[:user]=users(:aaron)
    get :index
    assert_response :success
    assert assigns(:users)
  end

  def test_should_show_user_to_admin
    @request.session[:user]=users(:quentin)
    get :show, :id => 1
    assert_response :success
  end

  def test_admin_should_get_edit
    @request.session[:user]=users(:john) #admin
    get :edit, :id => 2
    assert_response :success
  end

  def test_should_allow_user_create_by_admin
    @request.session[:user]=users(:quentin)
    count = User.count
    create_user
    assert_equal count+1, User.count 
    assert_response :redirect
  end
  
  def test_should_not_allow_user_create_by_nonadmin
    @request.session[:user]=users(:aaron)
    count = User.count
    create_user
    assert_equal count, User.count 
    assert_response :success
  end
  
  def test_xml_should_allow_user_create_by_admin
    @request.session[:user]=users(:quentin)
    count = User.count
    create_user_xml
    assert_equal count+1, User.count 
    assert_response 201 #created
  end
  
  def test_xml_format_should_send_failure_on_user_create_errors
    @request.session[:user]=users(:quentin)
    count = User.count
    create_user_xml(:login => nil)
    assert_response :success #403 forbidden would be better
    assert_equal count, User.count
    assert_select  "errors:root"
  end
  
  def test_should_not_allow_anonymous_user_create
    count = User.count
    create_user
    assert_equal count, User.count 
    assert_nil assigns(:user)
    assert_response :redirect 
  end
  
  def test_xml_admin_can_update_user
    @request.session[:user]=users(:john) #admin
    put :update, :id => 2, :format => 'xml', :user  => {:first_name  => "Ivan"}
    assert_response :success
    u = User.find(2)
    assert_equal 'Ivan', u.first_name
  end

  def test_should_require_login_on_signup
    @request.session[:user]=users(:quentin)
    count = User.count
    create_user(:login => nil)
    assert_equal count, User.count
    assert assigns(:user).errors.on(:login)
    assert_response :success
    #assert_no_difference User, :count do
    #  create_user(:login => nil)
    #  assert assigns(:user).errors.on(:login)
    #  assert_response :success
    #end
  end

  def test_should_require_password_on_signup
    @request.session[:user]=users(:quentin)
    count = User.count
    create_user(:password => nil)
    assert_equal count, User.count
    assert assigns(:user).errors.on(:password)
    assert_response :success
    #assert_no_difference User, :count do
    #  create_user(:password => nil)
    #  assert assigns(:user).errors.on(:password)
    #  assert_response :success
    #end
  end

  def test_should_require_password_confirmation_on_signup
    @request.session[:user]=users(:quentin)
    count = User.count
    create_user(:password_confirmation => nil)
    assert_equal count, User.count
    assert assigns(:user).errors.on(:password_confirmation)
    assert_response :success
    #assert_no_difference User, :count do
    #  create_user(:password_confirmation => nil)
    #  assert assigns(:user).errors.on(:password_confirmation)
    #  assert_response :success
    #end
  end

  def test_should_require_email_on_signup
    @request.session[:user]=users(:quentin)
    count = User.count
    create_user(:email => nil)
    assert_equal count, User.count
    assert assigns(:user).errors.on(:email)
    assert_response :success
    #assert_no_difference User, :count do
    #  create_user(:email => nil)
    #  assert assigns(:user).errors.on(:email)
    #  assert_response :success
    #end
  end
  
  #admin can access everybody
  def test_admin_should_get_all_users
    @request.session[:user]=users(:quentin)
    get :index, :format => 'xml'
    assert_response :success
    #puts @response.body
    assert_select "records:root>record>login", 'john'
    assert_select "records:root>record>login", 'aaron'
    assert_select "record", :count => User.count
    assert_select "groups", :count => User.count
  end
  
  #not admin can all users
  def test_not_admin_should_get_all_users
    @request.session[:user]=users(:aaron)
    get :index, :format => 'xml'
    assert_response :success
    assert_select "records:root>record>login", 'john'
    assert_select "records:root>record>login", 'aaron'
    assert_select "record", :count => User.count
    assert_select "groups", :count => User.count
  end
  
  #admin can delete user with cascade to dependent models
  #cascade is implemented on MySQL database level
  def test_admin_can_delete_user
    count_before = User.count
    count_memberships = Membership.count
    @request.session[:user]=users(:quentin)
    delete :destroy, :id => users(:lonely_user), :format => 'xml'
    assert_response 200
    assert_response :success
    assert_equal count_before - 1, User.count
    assert_equal count_memberships - 1,  Membership.count
  end
  
  
  def test_nonadmin_fails_deleting_user
    count_before = User.count
    @request.session[:user]=users(:aaron)
    delete :destroy, :id => users(:lonely_user), :format => 'xml'
    assert_response :ok #not authorized
    assert_select "errors:root>error", ERRORS[:not_authorized]
    assert_equal count_before, User.count
  end
  
  def test_cannot_delete_user_with_fk
    @request.session[:user]=users(:quentin)
    assert_no_difference('User.count') do
      delete :destroy, :id => users(:aaron), :format => 'xml'
    end
    assert_response :ok
    assert_select "errors:root>error", ERRORS[:foreign_key_problem]
  end

  protected
  
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :first_name => 'Es', :last_name => 'Quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end

    def create_user_xml(options = {})
      post_xml = '
<?xml version="1.0" encoding="UTF-8" ?>
<user>
  <login>quire</login>
  <first_name>Es</first_name>
  <last_name>Quire</last_name>
  <email>quire@example.com</email>
  <password>quire</password>
  <password_confirmation>quire</password_confirmation>
</user>'   
      user, user_data = xml_to_params(post_xml,options)
      post :create, :format => "xml", user => user_data
    end
end
