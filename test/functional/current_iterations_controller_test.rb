require File.dirname(__FILE__) + '/../test_helper'
require 'current_iterations_controller'

# Re-raise errors caught by the controller.
class CurrentIterationsController; def rescue_action(e) raise e end; end

class CurrentIterationsControllerTest < Test::Unit::TestCase

  def setup
    @controller = CurrentIterationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user]=users(:mary) #developer
  end
  
  def test_xml_should_get_index
    get  :index, :format => 'xml'
    assert_response :success
    assert_select 'iteration', 1
    assert_select 'iteration>id', '2'
    #puts @response.body
  end
end