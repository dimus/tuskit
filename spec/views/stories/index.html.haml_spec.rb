require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories" do
  fixtures :projects, :iterations, :stories
  
  before(:each) do
    @iteration = iterations(:admin_view)
    assigns[:project] = @iteration.project
    assigns[:iteration] = @iteration
    assigns[:stories] = @iteration.stories
    assigns[:meetings] = @iteration.meetings
  end


  it "should render stories" do
    render "/stories/index"
    response.should be_success
  end


end

