require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users" do
  before(:each) do
    @groups = [mock_model(Group, :name => 'developer')]
    @users = 6.times.map do |i|
      mock_model(User,
        :full_name => 'Full Name',
        :login => 'login',
        :email => 'email@example.org',
        :phone => 'phone',
        :groups => @groups
      )
    end
      assigns[:users] = @users
  end

  it "should render" do
    render "/users/index.html.haml"
    response.should be_success
  end

end
