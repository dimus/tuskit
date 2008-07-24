require File.dirname(__FILE__) + '/../../spec_helper'

describe "/meetings/new" do
  fixtures :projects, :iterations, :meetings, :users, :groups,:memberships

  before(:each) do
    @project = projects(:tuskit)
    @iteration = @project.iterations.first
    @meetings = @iteration.meetings
    assigns[:iteration] = @iteration
    assigns[:project] = @project
    assigns[:meeting] = Meeting.new
  end

  it "should render new meeting template" do
    render "/meetings/new.html.haml"
    response.should be_success
  end

end
