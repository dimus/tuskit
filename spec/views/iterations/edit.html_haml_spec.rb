require File.dirname(__FILE__) + '/../../spec_helper'

describe "/iteration" do
  
  before(:each) do
    @project = mock_model(Project)
    @iteration = mock_model(Iteration, 
      :objectives => 'objectives', 
      :project => @project,
      :work_units => 30,
      :start_date => 30.days.ago,
      :end_date => 10.days.ago
      )
    assigns[:project] = @project
    assigns[:iteration] = @iteration
  end

  it "should render features" do
    render "/iterations/edit.html.haml"
    response.should be_success
  end
  
  it "should have form" do
    render "/iterations/edit.html.haml"
    response.should have_tag("form[action=?][method=post]", iteration_path(@iteration)) do
      with_tag('textarea#iteration_objectives[name=?]', "iteration[objectives]")
      with_tag('input[type=?]', "submit")
    end
  end
  
  
end

