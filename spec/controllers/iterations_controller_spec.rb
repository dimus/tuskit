require File.dirname(__FILE__) + '/../spec_helper'

describe IterationsController, "with fixtures and views" do
  fixtures :projects, :iterations, :users, :groups, :memberships

  before(:each) do
    @project = projects(:tuskit)
    session[:user] = users(:aaron)
  end

  describe ".index" do
    before do
      @project.stub!(:move_incomplete_stories_to_current_iteration).and_return(nil)
    end

    it "should load index for developer" do
      get "index", :project_id => @project.id
      response.should be_success
    end

    it "should load index for admin" do
      session[:user] = users(:quentin) #admin
      get "index", :project_id => @project.id
      response.should be_success
    end

    it "should not load index for noone" do
      session[:user] = nil
      get "index", :project_id => @project.id
      response.should redirect_to("/sessions/new")
    end
      
  end

  describe ".show" do
    it "should redirect developer to index stories" do
      iteration = @project.iterations.first
      iteration.should be_instance_of(Iteration)
      get "show", :project_id => @project.id, :id => iteration.id
      response.should redirect_to("/iterations/#{iteration.id}/stories")
    end
  end

end

describe IterationsController, "routes" do
  it "should index route" do
    params_from(:get, "/projects/1/iterations").should == {:controller => "iterations", :action => "index", :project_id => "1"}
    route_for(:controller => "iterations", :action => "index", :project_id => 1).should == "/projects/1/iterations"
  end

  it "should have show route" do
    params_from(:get, "/projects/1/iterations/2").should == {:controller => "iterations", :action => "show", :id => "2", :project_id => "1"}
  end
end
