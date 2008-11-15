require File.dirname(__FILE__) + '/../../spec_helper'

describe "/project/1/milestones" do
  
  before(:each) do
    @milestone = Milestone.new
    @project = mock_model(Project)
    assigns[:project] = @project
    assigns[:milestone] = @milestone
  end

  it "should render" do
    render "/milestones/new.html.haml"
    response.should be_success
  end
  
  it "should have form" do
    render "/milestones/new.html.haml"
    response.should have_tag("form[action=/milestones][method=post]") do
          with_tag('input#milestone_name[name=?]', "milestone[name]")
          with_tag('input[type=?]', "submit")
          
    end
  end
  

end

