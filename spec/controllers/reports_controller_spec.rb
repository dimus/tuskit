require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do
  before do
    @project = mock_model(Project)
    @userr = mock_model(User)
    controller.stub!('current_user').and_return(@user)
    Project.stub!('find').and_return(@project)
  end
  

  #Delete this example and add some real ones
  it "should use ReportsController" do
    controller.should be_an_instance_of(ReportsController)
  end

  describe '.index' do
  
    it "should render" do
      Project.should_receive('find').and_return(@project)
      get "index", :project_id => @project.id
      response.should be_success
    end
  
  end

end
