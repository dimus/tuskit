require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeaturesController do
  before(:each) do
    @user ||= mock_model(User)
    @project ||= mock_model(Project)
    @milestone ||= mock_model(Milestone, :project => @project, :features => [mock_feature])
    Milestone.stub!(:find).and_return(@milestone)
    controller.stub!(:current_user).and_return(@user)
    controller.stub!(:developer?).and_return(true)
  end

  def mock_feature(stubs={})
    @mock_feature ||= mock_model(Feature, stubs)
  end
    
  describe "responding to GET index" do
    
    before do
      @features = [mock_feature]
      @milestone.should_receive(:features).and_return(@features)
    end
    
    it "should find @milestone and @project" do
      Milestone.should_receive(:find).and_return(@milestone)
      @milestone.should_receive(:project).and_return(@project)
      get :index, :milestone_id => @milestone.id
      assigns[:project].should == @project
      assigns[:milestone].should == @milestone
    end

    it "should expose all features" do
      get :index, :milestone_id => @milestone.id
      assigns[:features].should == @features
    end

    describe "with mime type of xml" do
  
      it "should render all features as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @features.should_receive(:to_xml).and_return("generated XML")
        get :index, :milestone_id => @milestone.id
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET new" do
  
    it "should expose a new feature as @feature" do
      Feature.should_receive(:new).and_return(mock_feature)
      get :new, :milestone_id => @milestone.id
      assigns[:feature].should equal(mock_feature)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested feature as @feature" do
      Feature.should_receive(:find).with("37").and_return(mock_feature)
      get :edit, :id => "37", :milestone_id => @milestone.id
      assigns[:feature].should equal(mock_feature)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created feature as @feature" do
        Feature.should_receive(:new).with({'mock' => 'params'}).and_return(mock_feature(:milestone => @milestone))
        mock_feature.should_receive(:save).and_return true
        post :create, :feature => {'mock' => 'params'}, :milestone_id => @milestone.id
        assigns(:feature).should equal(mock_feature)
      end

      it "should redirect to the created feature" do
        Feature.stub!(:new).with('mock' => 'params').and_return(mock_feature)
        mock_feature.should_receive(:save).and_return true
        post :create, :feature => {'mock' => 'params'}, :milestone_id => @milestone.id
        response.should redirect_to(milestone_features_url(@milestone))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved feature as @feature" do
        Feature.stub!(:new).with({'wrong' => 'params'}).and_return(mock_feature)
        mock_feature.should_receive(:save).and_return false
        post :create, :feature => {'wrong' => 'params'}
        assigns(:feature).should equal(mock_feature)
      end

      it "should re-render the 'new' template" do
        Feature.stub!(:new).and_return(mock_feature)
        mock_feature.should_receive(:save).and_return false
        post :create, :feature => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested feature" do
        Feature.should_receive(:find).with("37").and_return(mock_feature)
        mock_feature.should_receive(:update_attributes).with({'mock' => 'params'})
        put :update, :id => "37", :feature => {:mock => 'params'}
      end

      it "should expose the requested feature as @feature" do
        Feature.stub!(:find).and_return(mock_feature)
        mock_feature.should_receive(:update_attributes).with({'mock' => 'params'})
        put :update, :id => "1", :feature => {:mock => 'params'}
        assigns(:feature).should equal(mock_feature)
      end

      it "should redirect to the feature" do
        Feature.stub!(:find).and_return(mock_feature)
        mock_feature.should_receive(:update_attributes).with({'mock' => 'params'}).and_return true        
        put :update, :id => "1", :feature => {:mock => 'params'}, :milestone_id => @milestone.id
        response.should redirect_to(milestone_features_url(@milestone))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested feature" do
        Feature.should_receive(:find).with("37").and_return(mock_feature)
        mock_feature.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :feature => {:these => 'params'}
      end

      it "should expose the feature as @feature" do
        Feature.stub!(:find).and_return(mock_feature)
        mock_feature.should_receive(:update_attributes).and_return false        
        put :update, :id => "1"
        assigns(:feature).should equal(mock_feature)
      end

      it "should re-render the 'edit' template" do
        Feature.stub!(:find).and_return(mock_feature)
        mock_feature.should_receive(:update_attributes).and_return false        
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested feature" do
      Feature.should_receive(:find).with("37").and_return(mock_feature)
      mock_feature.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the features list" do
      Feature.stub!(:find).and_return(mock_feature)
      mock_feature.should_receive(:destroy).and_return true
      delete :destroy, :id => "1", :milestone_id => @milestone.id
      response.should redirect_to(milestone_features_url(@milestone))
    end

  end

end
