require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MilestonesController do
  describe "route generation" do

    it "should map { :controller => 'milestones', :action => 'index' } to /milestones" do
      route_for(:controller => "milestones", :action => "index").should == "/milestones"
    end
  
    it "should map { :controller => 'milestones', :action => 'new' } to /milestones/new" do
      route_for(:controller => "milestones", :action => "new").should == "/milestones/new"
    end
  
    it "should map { :controller => 'milestones', :action => 'show', :id => 1 } to /milestones/1" do
      route_for(:controller => "milestones", :action => "show", :id => 1).should == "/milestones/1"
    end
  
    it "should map { :controller => 'milestones', :action => 'edit', :id => 1 } to /milestones/1/edit" do
      route_for(:controller => "milestones", :action => "edit", :id => 1).should == "/milestones/1/edit"
    end
  
    it "should map { :controller => 'milestones', :action => 'update', :id => 1} to /milestones/1" do
      route_for(:controller => "milestones", :action => "update", :id => 1).should == "/milestones/1"
    end
  
    it "should map { :controller => 'milestones', :action => 'destroy', :id => 1} to /milestones/1" do
      route_for(:controller => "milestones", :action => "destroy", :id => 1).should == "/milestones/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'milestones', action => 'index' } from GET /milestones" do
      params_from(:get, "/milestones").should == {:controller => "milestones", :action => "index"}
    end
  
    it "should generate params { :controller => 'milestones', action => 'new' } from GET /milestones/new" do
      params_from(:get, "/milestones/new").should == {:controller => "milestones", :action => "new"}
    end
  
    it "should generate params { :controller => 'milestones', action => 'create' } from POST /milestones" do
      params_from(:post, "/milestones").should == {:controller => "milestones", :action => "create"}
    end
  
    it "should generate params { :controller => 'milestones', action => 'show', id => '1' } from GET /milestones/1" do
      params_from(:get, "/milestones/1").should == {:controller => "milestones", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'milestones', action => 'edit', id => '1' } from GET /milestones/1;edit" do
      params_from(:get, "/milestones/1/edit").should == {:controller => "milestones", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'milestones', action => 'update', id => '1' } from PUT /milestones/1" do
      params_from(:put, "/milestones/1").should == {:controller => "milestones", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'milestones', action => 'destroy', id => '1' } from DELETE /milestones/1" do
      params_from(:delete, "/milestones/1").should == {:controller => "milestones", :action => "destroy", :id => "1"}
    end
  end
end
