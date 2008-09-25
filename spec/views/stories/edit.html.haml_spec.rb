require File.dirname(__FILE__) + '/../../spec_helper'

describe "/iteration/1/stories/2/edit" do
  before do
    @project = mock_model(Project)
    @iteration = mock_model(Iteration, :project => @project)
    @story = mock_model(Story, 
      :iteration      => @iteration, 
      :name           => 'Story Name', 
      :description        => 'Story description',
      :work_units_est => '20',
      :completion_date      => nil,
      :agile_tasks    => [])
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
    response.should have_tag("form[action=#{story_path(@story)}][method=post]") do
          with_tag('input#story_name[name=?]', "story[name]")
          with_tag('textarea#story_description[name=?]', "story[description]")
          with_tag('input#story_work_units_est[name=?]', "story[work_units_est]")
          with_tag('input[type=?]', "submit")
          
    end
  end

end
