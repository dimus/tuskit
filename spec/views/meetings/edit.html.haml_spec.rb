require File.dirname(__FILE__) + '/../../spec_helper'

describe "/meetings/new" do
  fixtures :projects, :iterations, :meetings, :users, :groups,:memberships

  before(:each) do
    @iteration = iterations(:admin_view)
    @project = @iteration.project
    @meeting = @iteration.meetings.first
    assigns[:iteration] = @iteration
    assigns[:project] = @project
    assigns[:meeting] = @meeting
  end
  
  it "should render edit meeting template" do
    render "/meetings/edit.html.haml"
    response.should be_success
  end
  
end
