require File.dirname(__FILE__) + '/../../spec_helper'

describe "/user" do
  
  before(:each) do
    @groups = [mock_model(Group, :name => 'developer')]
    @user = mock_model(User,
      :first_name => 'name',
      :last_name => 'name',
      :login => 'login',
      :email => 'email',
      :password => 'password',
      :password_confirmation => 'password',
      :groups => @groups
    )
    Group.stub!(:find_all).and_return @groups
    assigns[:user] = @user
  end

  it "should render features" do
    render "/users/edit.html.haml"
    response.should be_success
  end
  
  it "should have form" do
    render "/users/edit.html.haml"
    response.should have_tag("form[action=?][method=post]", user_path(@user)) do
      with_tag('input#user_first_name[name=?]', "user[first_name]")
      with_tag('input[type=?]', "submit")
    end
  end
  
  
end

