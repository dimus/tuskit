require File.dirname(__FILE__) + '/../spec_helper'

describe AgileTasksController do

  before do
    @user = mock_model(User)
    controller.stub!(:current_user).and_return(@user)
    @to1 = mock_model(TaskOwner, :user => mock_model(User, :full_name => 'Aa Aa'))
    @to2= mock_model(TaskOwner, :user => mock_model(User, :full_name => 'Bb Bb'))
    @project = mock_model(Project)
    @iteration = mock_model(Iteration, :project => @project)
    @story = mock_model(Story, :iteration => @iteration)
    @new_task = mock_model(AgileTask, :story => @story, :name => 'New task')
    @old_task = mock_model(AgileTask, :story => @story, :task_owners => [@to1, @to2])
    AgileTask.stub!(:new).and_return(@new_task)
    Story.stub!(:find).and_return(@story)
    @params = {:story_id => @story.id, :name => 'Story name', :work_units_est => 3.0, :work_units_real => 0}
  end

  describe ".new" do
    it "should make a new agile task" do
      AgileTask.should_receive(:new).and_return(@new_task)
      get "new", :story_id => @story.id 
    end

    it "should find taks's story" do
      Story.should_receive(:find).and_return(@story)
      @story.should_receive(:iteration).and_return(@iteration)
      @iteration.should_receive(:project).and_return(@project)
      get "new", :story_id => @story.id 
    end

    it "should render page with success" do
      get "new", :story_id => @story.id
      response.should be_success
    end

    it "should redirect to login page if there is no logged in user" do
      controller.stub!(:current_user).and_return(:false) 
      get "new", :story_id => @story.id
      response.should be_redirect
    end
  end

  describe ".edit" do
    before do
      AgileTask.stub!(:find).and_return(@old_task)
    end

    it "should find an agile task" do
      AgileTask.should_receive(:find).and_return(@old_task)
      get "edit", :story_id => @story.id, :id => @old_task
    end
    
    it "should render page with success" do
      get "edit", :story_id => @story.id, :id => @old_task
      response.should be_success
    end

  end

  describe ".create" do
    before do
      @user2 = mock_model(User)
      AgileTask.stub!(:new).and_return(@new_task)
      controller.stub!(:developer?).and_return(true)
      @user.stub!(:login).and_return("spec")
      @new_task.stub!(:updated_by=).with(@user.login)
      @new_task.stub!(:created_by=).with(@user.login)
      @new_task.stub!(:save).and_return(true)
      @story.stub!(:iteration_id).and_return(@iteration)
    end

    it "should make a new agile task from parameters" do 
      AgileTask.should_receive(:new).and_return(@new_task)
      post "create", :agile_task => @params
    end

    it "shuld save new task" do
      @new_task.should_receive(:save).and_return(true)
      post "create", :agile_task => @params
    end

    it "should redirect to iteration stories index" do
      post "create", :agile_task => @params
      response.should redirect_to(iteration_stories_url(@iteration))
    end

    it "should set complete_date to current_date if @params agile_task_completed exists" do
      @new_task.should_receive(:completion_date=).with(Date.today)
      post "create", :agile_task => @params, :task_completed => 1
    end

    it "should add task_owners if user_ids exist" do
      User.should_receive(:find).with(@user.id).and_return(@user)
      TaskOwner.should_receive(:create).and_return(true)
      post "create", :agile_task => @params, :user_ids => [@user.id]
    end
  end

  describe ".update" do
    before do
      AgileTask.stub!(:find).and_return(@old_task)
      @params.merge!({:id => @old_task.id})
      controller.should_receive(:developer?).and_return(true)
      @user.stub!(:login).and_return("spec")
      @old_task.stub!(:updated_by=).with(@user.login)
      @old_task.stub!(:story_id).and_return(@story.id)
      @old_task.stub!(:name).and_return('Task name')
      @old_task.stub!(:task_owners).and_return([])
      @old_task.stub!(:update_attributes).and_return(true)
      TaskOwner.stub!(:find).and_return(nil)
      TaskOwner.stub!(:destroy).and_return(true)
    end

    it "should find agile task" do
      AgileTask.should_receive(:find).and_return(@old_task)
      put "update", :agile_task => @params, :id => @old_task.id
    end

    it "should update agile task information" do
      @old_task.should_receive(:update_attributes).and_return(true)
      put "update", :agile_task => @params, :id => @old_task.id
    end


    it "should redirect to iteration stories index" do
      put "update", :agile_task => @params, :id => @old_task.id
      response.should redirect_to(iteration_stories_url(@iteration))
    end
    
    it "should set complete_date to current_date if parameter task_completed exists" do
      @old_task.should_receive(:completion_date=).with(Date.today)
      put "update", :agile_task => @params, :id => @old_task.id, :task_completed => 1
    end
    
    it "should set complete_date to null if parameter task_not_completed exists" do
      @old_task.should_receive(:completion_date=).with(nil)
      put "update", :agile_task => @params, :id => @old_task.id, :task_not_completed => 1
    end

    it "should update task_owners if user_ids exist" do
      User.should_receive(:find).with(@user.id).and_return(@user)
      TaskOwner.should_receive(:create).and_return(true)
      put "update", :id => @old_task.id, :agile_task => @params, :user_ids => [@user.id]
    end


  end

  describe ".delete" do
    before do
      controller.should_receive(:developer?).and_return(true)
      AgileTask.stub!(:find).and_return(@old_task)
      Story.stub!(:find).and_return(@story)
      @story.stub!(:iteration_id).and_return(@iteration.id)
      @old_task.stub!(:destroy).and_return(true)
    end

    it "should find agile task" do
      AgileTask.should_receive(:find).and_return(@old_task)
      delete "destroy", :story_id => @story.id, :id => @old_task
    end

    it "should delete agile task" do
      @old_task.should_receive(:destroy).and_return(true)
      delete "destroy", :story_id => @story.id, :id => @old_task
    end

    it "should redirect to iteration stories index" do
      delete "destroy", :story_id => @story.id, :id => @old_task
      response.should redirect_to(iteration_stories_url(@iteration))
    end
  
  end

end

describe AgileTasksController, "routes" do
  
  it "should have new route" do
    params_from(:get, "/stories/1/agile_tasks/new").should == {:controller => "agile_tasks", :action => "new", :story_id => "1"}
    route_for(:controller => "agile_tasks", :action => "new", :story_id => "1").should == "/stories/1/agile_tasks/new"
  end

  it "should have edit route" do
    params_from(:get, "/stories/1/agile_tasks/2/edit").should == {:controller => "agile_tasks", :action => "edit", :story_id => "1", :id => "2"}
    route_for(:controller => "agile_tasks", :action => "edit", :story_id => 1, :id => "2").should == "/stories/1/agile_tasks/2/edit"
  end

  it "should have delete route" do
    params_from(:delete, "/stories/1/agile_tasks/2").should == {:controller => "agile_tasks", :action => "destroy", :story_id => "1", :id => "2"}
    route_for(:controller => "agile_tasks", :action => "destroy", :story_id => "1", :id => "2").should == "/stories/1/agile_tasks/2"
  end

end
