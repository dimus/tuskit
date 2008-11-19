require File.dirname(__FILE__) + '/../../spec_helper'

describe "/agile_tasks/new" do
  before do
    @developers = 3.times.map {|i| mock_model(ProjectMember, :full_name => "Full Name")}
    @project = mock_model(Project, :developers => @developers)
    @iteration = mock_model(Iteration, :project => @project)
    @agile_task = AgileTask.new()
    @story = mock_model(Story, 
      :iteration      => @iteration, 
      :name           => 'Story Name', 
      :description        => 'Story description',
      :work_units_est => '20',
      :completion_date      => nil,
      :agile_tasks    => [@agile_task]
      )
    assigns[:story]     = @story
    assigns[:iteration] = @iteration
    assigns[:project]   = @project
    assigns[:agile_task] = @agile_task
  end

  it "should render agile_tasks/edit" do
    render "/agile_tasks/edit.html.haml"
    response.should be_success
  end

  it "should have form" do
    render "/agile_tasks/edit.html.haml"
    response.should have_tag("form[action=/agile_tasks][method=post]") do
          with_tag('input#agile_task_name[name=?]', "agile_task[name]")
          with_tag('input[type=?]', "submit")
          
    end
  end

end
