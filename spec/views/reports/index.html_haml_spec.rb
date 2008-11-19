require File.dirname(__FILE__) + '/../../spec_helper'

describe "/reports" do

  before(:each) do
    @project = mock_model(Project, :name => 'project')
    @reports = 5.times.map do |i| 
      mock_model(Iteration, 
        :current? => false, 
        :start_date => (i * 20 - 10).days.ago, 
        :end_date => (i * 20 - 24).days.ago, 
        :objectives => 'objectives', 
        :work_units => 199, 
        :work_units_real => 22)
    end
    @reports[0].stub!(:current?).and_return true
    @project.stub!(:current_iteration).and_return(@reports[0])
    assigns[:project] = @project 
    assigns[:reports] = @reports
  end

  it "should render" do
    template.should_receive(:will_paginate).with(@reports)
    render "/reports/index.html.haml"
    response.should be_success
  end

end
