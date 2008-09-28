require File.dirname(__FILE__) + '/../spec_helper'

describe StoriesController do

  before(:each) do
    @user = mock_model(User)
    @project = mock_model(Project, :id => 1)
    @story_old = mock_model(Story)
    @story_old2 = mock_model(Story)
    @meeting = mock_model(Meeting, :meeting_date => Date.today, :name => 'Iteration Meeting')
    @meeting2 = mock_model(Meeting, :meeting_date => 20.days.ago, :name => 'Iteration Meeting')
    @iteration = mock_model(Iteration, :project => @project, :stories => [@story_old], :meetings => [@meeting])
    @iteration2 = mock_model(Iteration, :project => @project, :stories => [@story_old2], :meetings => [@meeting2])
    @story = mock_model(Story, :iteration => @iteration)
    @story_old.stub!(:iteration).and_return(@iteration)
    @project.stub!(:iterations).and_return([@iteration,@iteration2])
    Story.stub!(:new).and_return(@story)
    Iteration.stub!(:find).and_return(@iteration)
    controller.stub!(:current_user).and_return(@user)
    @params = {:story_name => "New Story", :work_units_est => 20, :iteration_id => @iteration.id}
  end

  describe ".index" do
    it "should load the index page for developer" do
      @project.should_receive(:copy_incomplete_stories_to_current_iteration).and_return(nil)
      @iteration.should_receive(:stories_prepare).and_return([@story])
      get "index", :iteration_id => @iteration.id
      response.should be_success
    end
  end

  describe ".new" do
    it "should load the new page" do
      Story.should_receive(:new).and_return(@story)
      get "new", :iteration_id => @iteration.id
      response.should be_success
    end
  end

  describe ".edit" do
    it "should load the edit page for developer" do
      Story.should_receive(:find).and_return(@story_old)
      get "edit", :iteration_id => @iteration.id, :id => @story_old.id
      response.should be_success
    end
  end

  describe ".create" do
    before do
      Story.should_receive(:new).and_return(@story)
      controller.should_receive(:developer?).and_return(true)
      @story.should_receive(:save).and_return(true)
    end
    
    it "should create new story from parameters" do
      post "create", :story => @params
    end

    it "should redirect to stories index" do
      post "create", :story => @params
      response.should redirect_to(iteration_stories_url(@iteration, :anchor => "story_" + @story.id.to_s))
    end
  
  end

  describe ".update" do 

    before do
      Story.stub!(:find).and_return(@story_old)
      @story_old.stub!(:update_attributes).and_return(true)
      controller.should_receive(:developer?).and_return(true)
    end

    it "should find story" do
      Story.should_receive(:find).and_return(@story_old)
      put "update", :story => @params, :id => @story_old.id
    end

    it "should update story's attributes" do
      @story_old.should_receive(:update_attributes).and_return(true)
      put "update", :story => @params, :id => @story_old.id
    end

    it "should redirect to iteration stories index" do
      put "update", :story => @params, :id => @story_old.id
      response.should redirect_to(iteration_stories_url(@story_old.iteration, :anchor => "story_" + @story_old.id.to_s))
    end

  end

  describe ".delete" do
    before do
      controller.should_receive(:developer?).and_return(true) 
      Story.stub!(:find).and_return(@story_old)
      @story_old.stub!(:destroy).and_return(true)
    end

    it "should find story" do
      Story.should_receive(:find).and_return(@story_old)
      delete "destroy", :id => @story_old.id
    end

    it "should call destroy method" do
      @story_old.should_receive(:destroy)
      delete "destroy", :id => @story_old.id
    end

    it "should redirect to iteration stories" do
      delete "destroy", :id => @story_old.id
      response.should redirect_to(iteration_stories_url(@iteration))
    end
  end
end


describe StoriesController, "routes" do
  
  it "should route to index" do
    params_from(:get, "/iterations/1/stories").should == {:controller => "stories",
    :action => "index", :iteration_id => "1"}
    route_for(:controller => "stories", :action => "index", :iteration_id => 1).should == "/iterations/1/stories"
  end

  it "should route to new" do
    params_from(:get, "/iterations/1/stories/new").should == {:controller => "stories",
    :action => "new", :iteration_id => "1"}
    route_for(:controller => "stories", :action => "new", :iteration_id => 1).should == "/iterations/1/stories/new"
  end

  it "should route to edit" do
    params_from(:get, "/iterations/1/stories/2/edit").should == {:controller => "stories",
    :action => "edit", :iteration_id => "1", :id => "2"}
    route_for(:controller => "stories", :action => "edit", :iteration_id => 1, :id => "2").should == "/iterations/1/stories/2/edit"
  end

end
