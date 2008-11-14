class FeaturesController < ApplicationController
  
  before_filter :project_milestone_find
  
  # GET /stories
  # GET /stories.xml
  def index
    @features = @milestone.features
    respond_to do |format|
      format.html
      format.xml { render :xml => @features }
    end
  end

  # GET /features/new
  # GET /features/new.xml
  def new
    @feature = Feature.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
  end

  # POST /features
  # POST /features.xml
  def create
    @feature = Feature.new(params[:feature])

    respond_to do |format|
      if @feature.save
        flash[:notice] = 'Feature was successfully created.'
        format.html { redirect_to milestone_features_url(@milestone) }
        format.xml  { render :xml => @feature, :status => :created, :location => @feature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.xml
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        flash[:notice] = 'Feature was successfully updated.'
        format.html { redirect_to milestone_features_url(@milestone) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.xml
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to milestone_features_url(@milestone) }
      format.xml  { head :ok }
    end
  end

protected
  def init
    @current_subtab = "Milestones"
  end

  def project_milestone_find
    milestone_id = params[:milestone_id] || params[:feature][:milestone_id] rescue nil
    @milestone = milestone_id ? Milestone.find(milestone_id) : nil
    @project = @milestone ? @milestone.project : nil
  end
end
