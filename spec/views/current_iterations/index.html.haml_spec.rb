require File.dirname(__FILE__) + '/../../spec_helper'

describe "/current_iterations" do
  before(:each) do
    @project_98 = mock(Project)
    @project_99 = mock(Project)
    @project_100 = mock(Project)

    @project_98.stub!(:id).and_return(98)
    @project_98.stub!(:name).and_return('Project 98')
    @project_98.stub!(:work_units_real).and_return(18.5)
    @project_98.stub!(:progress_reports).and_return(true)
    @project_98.stub!(:users).and_return([])

    @project_99.stub!(:id).and_return(99)
    @project_99.stub!(:name).and_return('Project 99')
    @project_99.stub!(:work_units_real).and_return(11)
    @project_99.stub!(:progress_reports).and_return(false)
    @project_99.stub!(:users).and_return([])

    @project_100.stub!(:id).and_return(100)
    @project_100.stub!(:name).and_return('Project 100')
    @project_100.stub!(:work_units_real).and_return(2)
    @project_100.stub!(:progress_reports).and_return(true)
    @project_100.stub!(:users).and_return([])
    
    @iter_98 = mock(Iteration)
    @iter_99 = mock(Iteration)
    @iter_98 = stub!(:project).and_return(@project_98)
    @iter_99 = stub!(:project).and_return(@project_99)
    assigns[:all_projects] = [@project_98, @project_99, @project_100]
    assigns[:iterations] = []
  end


  it "should have 2 subsections: 'Active projects' and 'All projects'" do
    render "/current_iterations/index"
    response.should be_success
    response.should have_tag('fieldset.subsection', 2)
    response.should have_tag('legend.subsection', :text => "My Active Projects")
    response.should have_tag('legend.subsection', :text => "All Projects")
    response.should have_tag('table[class=data bordered]')
  end

  describe 'no projects at all' do 
    before(:each) do
      assigns[:all_projects] = []
      render "/current_iterations/index"
    end
    
    it "should display only 'All projects' subsection when there are no projects" do
      response.should be_success
      response.should_not have_tag('legend.subsection', :text => "My Active Projects")    
      response.should have_tag('legend.subsection', :text => "All Projects")
    end
  
    it "should display only Add project link when there are no projects" do
      response.should_not have_tag('table[class=data bordered]')
      response.should have_tag('a', :text => "Add Project")      
    end
  
  end
  
  describe 'no active projects' do
    before(:each) do
      assigns[:all_projects] = [@project_98, @project_99, @project_100]
      render "/current_iterations/index.html.haml"
      response.should be_success
    end
    
    it "should display information how to create active projects when they dont exist" do
      response.should have_tag('.info-div')
      response.should include_text("You have no active projects")
    end

    it "should display table with projects in 'All projects' subsection when there are some" do
      response.should have_tag('table[class=data bordered]')
      response.should have_tag('th', :text => 'Project')
    end
  end

end
