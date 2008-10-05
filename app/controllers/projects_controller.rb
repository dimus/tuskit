class ProjectsController < ApplicationController
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.find(:all, :order => "name")
    respond_to do |format|
      format.html # index.erb
      format.xml  { render :xml => @projects.to_xml(:methods => [:work_units_real,:current_iteration_resource]) }
    end
  end
  
  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    
    respond_to do |format|
      format.html # show.erb
      format.xml  { render :xml => @project.to_xml(:methods => [:work_units_real]) }
    end
  end
  
  # GET /projects/new
  def new
    @project = Project.new
  end
  
  # GET /projects/1;edit
  def edit
    @project = Project.find(params[:id])
  end
  
  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    
    respond_to do |format|
      if developer?
        if @project.save
          flash[:notice] = 'Project was successfully created.'
          format.html { redirect_to project_project_members_url(@project) }
          format.xml  { render :status => :created, :xml  => @project.to_xml }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @project.errors.to_xml }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end
  
  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])
    
    respond_to do |format|
      if developer?
        if @project.update_attributes(params[:project])
          if params[:project].size == 1 && params[:project].key?("progress_reports")
            format.html { redirect_to current_iterations_url}
            format.xml {head :ok}
          else
            flash[:notice] = 'Project was successfully updated.'
            format.html { redirect_to edit_project_url(@project) }
            format.xml  { head :ok }
          end
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @project.errors.to_xml }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end
  
  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    project_name = @project.name
    begin
      respond_to do |format|
        if developer?
          @project.destroy
          flash[:notice] = "Project #{project_name} was successfully updated."
          format.html { redirect_to current_iterations_url }
          format.xml  { head :ok }
        else
          format.xml { render :xml => XML_ERRORS[:not_authorized] }
        end
      end
    rescue ActiveRecord::StatementInvalid 
      respond_to do |format| 
        format.xml  { render :xml => XML_ERRORS[:foreign_key_problem] } 
      end
    end
  end
  
protected
  def init
    @current_subtab = "Project"
  end
end
