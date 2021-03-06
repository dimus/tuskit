require File.dirname(__FILE__) + '/../../spec_helper'

describe "/iterations" do
  before(:each) do
    @project = mock_model(Project, :name => 'project')
    @iterations = 5.times.map do |i| 
      mock_model(Iteration, 
        :current? => false, 
        :start_date => (i * 20 - 10).days.ago, 
        :end_date => (i * 20 - 24).days.ago, 
        :objectives => 'objectives', 
        :work_units => 199, 
        :work_units_real => 22)
    end
    @iterations[0].stub!(:current).and_return true
    assigns[:project] = @project 
    assigns[:iterations] = @iterations
  end

  it "should render" do
    render "/iterations/index.html.haml"
    response.should be_success
  end

end
