require File.dirname(__FILE__) + '/../../spec_helper'

describe "/features" do
  
  before(:each) do
    @project = mock_model(Project)
    @iteration = Iteration.new( 
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
    render "/iterations/new.html.haml"
    response.should be_success
  end
  
  it "should have form" do
    render "/iterations/new.html.haml"
    response.should have_tag("form[action=/iterations][method=post]") do
      with_tag('textarea#iteration_objectives[name=?]', "iteration[objectives]")
      with_tag('input[type=?]', "submit")
    end
  end
  
  
end

