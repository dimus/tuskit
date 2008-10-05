class IterationsController < ApplicationController
  
  # GET /iterations
  # GET /iterations.xml
  def index
    @project = Project.find(params[:project_id])
    @project.copy_incomplete_stories_to_current_iteration
    @iterations = @project.iterations
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @iterations.to_xml(:methods => [:daily_load,:work_units_real, :agile_tasks_number]) }
    end
  end

  # GET /iterations/1
  # GET /iterations/1.xml
  def show
    @iteration = Iteration.find(params[:id])
    @project = @iteration.project
    collapse_stories ={:collapse =>  session["collapse_iteration_" + params[:id].to_s] ? true : false}
    respond_to do |format|
      format.html { redirect_to :controller => "stories", :action => "index", :iteration_id => @iteration.id }
      format.xml  { render :xml => @iteration.to_xml(:methods => [:daily_load,:work_units_real, :agile_tasks_number]) }
      format.json { render :json => collapse_stories.to_json } 
    end
  end

  # GET /iterations/new
  # GET /iterations/new.xml
  def new
    @project = Project.find(params[:project_id]) 
    work_units = @project.iterations.sort_by(&:start_date).last.work_units rescue 0.0
    @iteration = Iteration.new(:project => @project, :start_date => 0.days.from_now, :end_date => @project.iteration_length.days.from_now, :work_units => work_units)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @iteration.to_xml(:methods => [:daily_load,:work_units_real, :agile_tasks_number]) }
    end
  end

  # GET /iterations/1/edit
  def edit
    @iteration = Iteration.find(params[:id])
    @project = @iteration.project
  end

  # GET /iterations/1/is_collapsed
  def is_collapsed
      
  end

  # POST /iterations
  # POST /iterations.xml
  def create
    @iteration = Iteration.new(params[:iteration])

    respond_to do |format|
      if developer?
        if @iteration.save
          flash[:notice] = 'Iteration was successfully created.'
          format.html { redirect_to(project_iteration_url(@iteration.project,@iteration)) }
          format.xml  { render :xml => @iteration, :status => :created, :location => @iteration }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @iteration.errors, :status => :unprocessable_entity }
        end
      else
       format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # PUT /iterations/1
  # PUT /iterations/1.xml
  def update
    @iteration = Iteration.find(params[:id])
    #remember collapsing state of stories
    session["collapse_iteration_" + params[:id].to_s] = (params[:collapse] == "true") if params[:collapse]

    respond_to do |format|
      if developer? && params[:iteration]
        if @iteration.update_attributes(params[:iteration])
          flash[:notice] = 'Iteration was successfully updated.'
          format.html { redirect_to(project_iteration_url(@iteration.project,@iteration)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @iteration.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # DELETE /iterations/1
  # DELETE /iterations/1.xml
  def destroy
    @iteration = Iteration.find(params[:id])
    @project = @iteration.project
    begin
      respond_to do |format|
        if developer?
          @iteration.destroy
          format.html { redirect_to(project_iterations_url(@project)) }
          format.xml  { head :ok }
        else
          format.xml { render :xml => XML_ERRORS[:not_authorized]}
        end
      end
    rescue ActiveRecord::StatementInvalid 
      respond_to do |format| 
        format.xml  { render  :xml => XML_ERRORS[:foreign_key_problem] } 
      end
    end      
  end

protected
  def init
    @current_subtab = "Iterations"
  end
end
