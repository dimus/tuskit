require File.dirname(__FILE__) + '/../../spec_helper'

describe "/agile_tasks/edit" do
  before do
    @developers = 3.times.map {|i| mock_model(ProjectMember, :full_name => "Full Name")}
    @project = mock_model(Project, :developers => @developers)
    @iteration = mock_model(Iteration, :project => @project)
    @agile_task = mock_model(AgileTask, :completion_date => nil, :name => "Name", :bug => false, :task_owners => @developers[0..1], :owners => [@developers[0]], :notes => '', :task_units => 3)
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
    response.should have_tag("form[action=?][method=post]", agile_task_path(@agile_task)) do
          with_tag('input#agile_task_name[name=?]', "agile_task[name]")
          with_tag('input[type=?]', "submit")
          
    end
  end

end
