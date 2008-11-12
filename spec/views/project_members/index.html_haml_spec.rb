require File.dirname(__FILE__) + '/../../spec_helper'

describe "/project/project_members" do
  before(:each) do
    @project = mock_model(Project)
    @g1 = mock_model(Group, :name => "developer")
    @u1 = mock_model(User, :full_name => "full name", :groups => [@g1])
    @u2 = mock_model(User, :full_name => "full name", :groups => [@g1])
    @u3 = mock_model(User, :full_name => "full name", :groups => [@g1])
    @pm1 = mock_model(ProjectMember, :user => @u1, :project => @project, :send_iteration_report => true)
    @pm2 = mock_model(ProjectMember, :user => @u2, :project => @project, :send_iteration_report => false)
    assigns[:project] = @project
    assigns[:project_members] = [@pm1, @pm2]
    assigns[:project_non_members] = [@u3]
  end

  it "should render" do
    render "/project_members/index.html.haml"
    response.should be_success
  end

end
