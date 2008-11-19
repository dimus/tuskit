require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/new" do
  before do
    @features =  8.times.map {|i| mock_model(Feature, :name => 'feature')}
    @milestone = mock_model(Milestone, :features => @features)
    @project = mock_model(Project, :current_milestone => @milestone)
    @iteration = mock_model(Iteration, :project => @project)
    
    @story = Story.new( 
      :iteration      => @iteration, 
      :name           => 'Story Name', 
      :description        => 'Story description',
      :work_units_est => '20',
      :completion_date      => nil,
      :agile_tasks    => [],
      :features => @features[1..2])
    assigns[:story]     = @story
    assigns[:iteration] = @iteration
    assigns[:project]   = @project
  end

  it "should render story edit" do
    render "/stories/edit"
    response.should be_success
  end

  it "should have form" do
    render "/stories/edit"
    response.should have_tag("form[action=/stories][method=post]") do
          with_tag('input#story_name[name=?]', "story[name]")
          with_tag('textarea#story_description[name=?]', "story[description]")
          with_tag('input#story_work_units_est[name=?]', "story[work_units_est]")
          with_tag('input[type=?]', "submit")
          
    end
  end

end
