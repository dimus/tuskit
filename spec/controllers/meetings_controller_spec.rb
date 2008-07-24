require File.dirname(__FILE__) + '/../spec_helper'

describe MeetingsController, "with fixtures" do
  fixtures :projects, :iterations, :meetings, :users, :groups, :memberships

  before(:each) do
    session[:user] = users(:aaron) #login as developer
    @iteration =  iterations(:admin_view)
    @meeting = @iteration.meetings.first
    @project = @iteration.project
  end

  describe ".new" do
    it "should load the new page for developer" do
      get "new", :iteration_id => @iteration.id
      response.should be_success
    end
  end

  describe ".edit" do
    it "should load the edit page for developer" do
      get "edit", :iteration_id => @iteration.id, :id => @meeting.id
      response.should be_success
    end
  end

  describe "handling POST /iterations/2/meetings" do
    before(:each) do
      @iteration = mock_model(Iteration, :id => 1)
      @meeting = mock_model(Meeting, :id => 2, :iteration => @iteration)
      Meeting.stub!(:new).and_return(@meeting)
      Iteration.stub!(:find).and_return(@iteration)
      @params = {:meeting_date => Date.today, :name => 'Iteration meeting', :iteration_id => 1}
    end
    
    describe "with successful save" do
      def do_post
        post :create, :meeting => @params, :users => []
      end

      it "should create new meeting" do
        Meeting.should_receive(:new).with(anything()).and_return(@meeting)
        do_post
      end

      it "should continue with no users parameter" do
        controller.should_receive(:developer?).and_return(true)
        @meeting.should_receive(:save).and_return(true)
        post :create, :meeting => @params
        response.should redirect_to(iteration_stories_url(@iteration))
      end

      it "should redirect to iteration stories" do
        controller.should_receive(:developer?).and_return(true)
        @meeting.should_receive(:save).and_return(true)
        do_post
        response.should redirect_to(iteration_stories_url(@iteration))
      end
    end

  end

    
  describe "handling DELETE /iterations/2/meetings/1" do

    before(:each) do
      @iteration = mock_model(Iteration)
      @meeting = mock_model(Meeting, :destroy => true, :iteration => @iteration)
      Meeting.stub!(:find).and_return(@meeting)
    end
                          
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find meeting" do
      Meeting.should_receive(:find).with("1").and_return(@meeting)
      do_delete
    end
                                                              
    it "should call destroy on the meeting" do
      @meeting.should_receive(:destroy)
      do_delete
    end
                                                                                    
    it "should redirect to the iteration stories list" do
      do_delete
      response.should redirect_to(iteration_stories_url(@iteration))
    end
  end

end

describe StoriesController, "routes" do
  
  it "should have new route" do
    params_from(:get, "/iterations/1/meetings/new").should == {:controller => "meetings", :action => "new", :iteration_id => "1"}
    route_for(:controller => "meetings", :action => "new", :iteration_id => "1").should == "/iterations/1/meetings/new"
  end
  
  it "should have edit route" do
    params_from(:get, "/iterations/1/meetings/2/edit").should == {:controller => "meetings", :action => "edit", :iteration_id => "1", :id => "2"}
    route_for(:controller => "meetings", :action => "edit", :iteration_id => 1, :id => "2").should == "/iterations/1/meetings/2/edit"
  end

  it "should have delete route" do
    params_from(:delete, "/iterations/1/meetings/2").should == {:controller => "meetings", :action => "destroy", :iteration_id => "1", :id => "2"}
    route_for(:controller => "meetings", :action => "destroy", :iteration_id => "1", :id => "2").should == "/iterations/1/meetings/2"
  end
end
