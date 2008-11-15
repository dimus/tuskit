require File.dirname(__FILE__) + '/../../spec_helper'

describe "/milestones" do

  describe "with milestones" do

    before(:each) do
      @milestones = 4.times.map {|i| mock_model(Milestone, :name => 'name' + i.to_s, :description => 'descr' + i.to_s, :deadline => nil)}
      @project = mock_model(Project, :milestones => @milestones)
      assigns[:project] = @project
      assigns[:milestones] = @milestones
    end

    it "should render" do
      render "/milestones/index.html.haml"
      response.should be_success
    end

  end

end

