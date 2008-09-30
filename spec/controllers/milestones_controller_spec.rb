require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MilestonesController do
  before(:each) do 
    @user = mock_model(User)
    @project ||= mock_model(Project)
    controller.stub!(:current_user).and_return(@user)
    controller.stub!(:developer?).and_return(true)
    Project.stub!(:find).and_return(@project)
  end

  def mock_milestone(stubs={})
    stubs.merge!({:project_id => @project.id})
    @mock_milestone ||= mock_model(Milestone, stubs)
  end
  
  describe "responding to GET index" do
    
    before(:each) do
      @project.stub!(:milestones).and_return([mock_milestone])
    end

    it "should expose all project milestones as @milestones" do
      @project.should_receive(:milestones).and_return([mock_milestone])
      get :index, :project_id => @project.id
      assigns[:milestones].should == [mock_milestone]
    end

    describe "with mime type of xml" do
  
      it "should render all milestones as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @project.should_receive(:milestones).and_return(milestones = mock("Array of Milestones"))
        milestones.should_receive(:to_xml).and_return("generated XML")
        get :index, :project_id => @project.id
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested milestone as @milestone" do
      Milestone.should_receive(:find).with("37").and_return(mock_milestone)
      get :show, :id => "37"
      assigns[:milestone].should equal(mock_milestone)
    end
    
    describe "with mime type of xml" do

      it "should render the requested milestone as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Milestone.should_receive(:find).with("37").and_return(mock_milestone)
        mock_milestone.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new milestone as @milestone" do
      Milestone.should_receive(:new).and_return(mock_milestone)
      get :new
      assigns[:milestone].should equal(mock_milestone)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested milestone as @milestone" do
      Milestone.should_receive(:find).with("37").and_return(mock_milestone)
      get :edit, :id => "37"
      assigns[:milestone].should equal(mock_milestone)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created milestone as @milestone" do
        Milestone.should_receive(:new).with({'these' => 'params'}).and_return(mock_milestone(:save => true))
        post :create, :milestone => {:these => 'params'}
        assigns(:milestone).should equal(mock_milestone)
      end

      it "should redirect to the created milestone" do
        Milestone.stub!(:new).and_return(mock_milestone(:save => true))
        post :create, :milestone => {}
        response.should redirect_to(milestone_url(mock_milestone))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved milestone as @milestone" do
        Milestone.stub!(:new).with({'these' => 'params'}).and_return(mock_milestone(:save => false))
        post :create, :milestone => {:these => 'params'}
        assigns(:milestone).should equal(mock_milestone)
      end

      it "should re-render the 'new' template" do
        Milestone.stub!(:new).and_return(mock_milestone(:save => false))
        post :create, :milestone => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested milestone" do
        Milestone.should_receive(:find).with("37").and_return(mock_milestone)
        mock_milestone.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :milestone => {:these => 'params'}
      end

      it "should expose the requested milestone as @milestone" do
        Milestone.stub!(:find).and_return(mock_milestone(:update_attributes => true))
        put :update, :id => "1"
        assigns(:milestone).should equal(mock_milestone)
      end

      it "should redirect to the milestone" do
        Milestone.stub!(:find).and_return(mock_milestone(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(milestone_url(mock_milestone))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested milestone" do
        Milestone.should_receive(:find).with("37").and_return(mock_milestone)
        mock_milestone.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :milestone => {:these => 'params'}
      end

      it "should expose the milestone as @milestone" do
        Milestone.stub!(:find).and_return(mock_milestone(:update_attributes => false))
        put :update, :id => "1"
        assigns(:milestone).should equal(mock_milestone)
      end

      it "should re-render the 'edit' template" do
        Milestone.stub!(:find).and_return(mock_milestone(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do


    it "should destroy the requested milestone" do
      Milestone.should_receive(:find).with("37").and_return(mock_milestone)
      mock_milestone.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the milestones list" do
      Milestone.stub!(:find).and_return(mock_milestone(:destroy => true))
      delete :destroy, :id => "1", :project_id => @project.id
      response.should redirect_to(project_milestones_url(@project))
    end

  end

end
