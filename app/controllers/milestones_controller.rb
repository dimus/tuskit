class MilestonesController < ApplicationController
  layout "user"

  before_filter :project_find
  
  # GET /milestones
  # GET /milestones.xml
  def index
    @milestones = @project.milestones

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @milestones }
    end
  end

  # GET /milestones/1
  # GET /milestones/1.xml
  def show
    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @milestone }
    end
  end

  # GET /milestones/new
  # GET /milestones/new.xml
  def new
    @milestone = Milestone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @milestone }
    end
  end

  # GET /milestones/1/edit
  def edit
    @milestone = Milestone.find(params[:id])
  end

  # POST /milestones
  # POST /milestones.xml
  def create
    @milestone = Milestone.new(params[:milestone])
    @milestone.deadline = nil unless params[:show_deadline]
    respond_to do |format|
      if developer? && @milestone.save
        flash[:notice] = 'Milestone was successfully created.'
        format.html { redirect_to(@milestone) }
        format.xml  { render :xml => @milestone, :status => :created, :location => @milestone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /milestones/1
  # PUT /milestones/1.xml
  def update
    @milestone = Milestone.find(params[:id])
    @milestone.deadline = nil unless params[:show_deadline]

    respond_to do |format|
      if @milestone.update_attributes(params[:milestone])
        flash[:notice] = 'Milestone was successfully updated.'
        format.html { redirect_to(@milestone) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.xml
  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    respond_to do |format|
      format.html { redirect_to(project_milestones_url(@project)) }
      format.xml  { head :ok }
    end
  end

protected
  def init
    @current_subtab = "Milestones"
  end

  def project_find
    @project = params[:project_id] ? Project.find(params[:project_id]) : nil
  end
end
