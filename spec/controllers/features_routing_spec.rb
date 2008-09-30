require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeaturesController do
  describe "route generation" do

    it "should map { :controller => 'features', :action => 'index' } to /features" do
      route_for(:controller => "features", :action => "index").should == "/features"
    end
  
    it "should map { :controller => 'features', :action => 'new' } to /features/new" do
      route_for(:controller => "features", :action => "new").should == "/features/new"
    end
  
    it "should map { :controller => 'features', :action => 'show', :id => 1 } to /features/1" do
      route_for(:controller => "features", :action => "show", :id => 1).should == "/features/1"
    end
  
    it "should map { :controller => 'features', :action => 'edit', :id => 1 } to /features/1/edit" do
      route_for(:controller => "features", :action => "edit", :id => 1).should == "/features/1/edit"
    end
  
    it "should map { :controller => 'features', :action => 'update', :id => 1} to /features/1" do
      route_for(:controller => "features", :action => "update", :id => 1).should == "/features/1"
    end
  
    it "should map { :controller => 'features', :action => 'destroy', :id => 1} to /features/1" do
      route_for(:controller => "features", :action => "destroy", :id => 1).should == "/features/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'features', action => 'index' } from GET /features" do
      params_from(:get, "/features").should == {:controller => "features", :action => "index"}
    end
  
    it "should generate params { :controller => 'features', action => 'new' } from GET /features/new" do
      params_from(:get, "/features/new").should == {:controller => "features", :action => "new"}
    end
  
    it "should generate params { :controller => 'features', action => 'create' } from POST /features" do
      params_from(:post, "/features").should == {:controller => "features", :action => "create"}
    end
  
    it "should generate params { :controller => 'features', action => 'show', id => '1' } from GET /features/1" do
      params_from(:get, "/features/1").should == {:controller => "features", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'features', action => 'edit', id => '1' } from GET /features/1;edit" do
      params_from(:get, "/features/1/edit").should == {:controller => "features", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'features', action => 'update', id => '1' } from PUT /features/1" do
      params_from(:put, "/features/1").should == {:controller => "features", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'features', action => 'destroy', id => '1' } from DELETE /features/1" do
      params_from(:delete, "/features/1").should == {:controller => "features", :action => "destroy", :id => "1"}
    end
  end
end
