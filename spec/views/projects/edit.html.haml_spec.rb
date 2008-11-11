require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/1/edit.html.haml" do
  before do
    @project = mock_model(Project, :name => 'name', :description => 'description', :start_date => 5.days.ago, :iteration_length => 14, :progress_reports => true)
    assigns[:project]   = @project
  end

  it "should render projects edit" do
    render '/projects/edit.html.haml'
    response.should be_success
  end

  it "should have form" do
    render "/projects/edit.html.haml"
    response.should have_tag("form[action=?][method=post]", project_path(@project)) do
          with_tag('input#project_name[name=?]', "project[name]")
          with_tag('input[type=?]', "submit")
          
    end
  end

end
