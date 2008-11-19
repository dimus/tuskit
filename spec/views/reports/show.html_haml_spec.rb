require File.dirname(__FILE__) + '/../../spec_helper'

describe "/reports/show" do

  before(:each) do
    @project = mock_model(Project, :name => 'project')
    @report = mock_model(Iteration, 
        :current? => false, 
        :start_date => 34.days.ago, 
        :end_date => 10.days.ago, 
        :objectives => 'objectives', 
        :work_units => 80,
        :work_units_planned => 50,
        :work_units_real => 22)
        
    @stories = 5.times.map do |i|
      mock_model(Story, 
        :completion_date => (10 - rand(24)).days.ago,
        :name => 'story_' + i.to_s,
        :work_units_est => 33,
        :iteration => @report
        )
    end
    @report.stub!(:stories).and_return @stories
    
    @project.stub!(:current_iteration).and_return(nil)
    assigns[:project] = @project 
    assigns[:report] = @report
  end

  it "should render" do
    render "/reports/show.html.haml"
    response.should be_success
  end

end
