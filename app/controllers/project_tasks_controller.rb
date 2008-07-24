class ProjectTasksController < ApplicationController
  # GET /project_tasks
  # GET /project_tasks.xml
  def index
    @project_tasks = ProjectTask.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_tasks }
    end
  end

  # GET /project_tasks/1
  # GET /project_tasks/1.xml
  def show
    @project_task = ProjectTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_task }
    end
  end

  # GET /project_tasks/new
  # GET /project_tasks/new.xml
  def new
    @project_task = ProjectTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_task }
    end
  end

  # GET /project_tasks/1/edit
  def edit
    @project_task = ProjectTask.find(params[:id])
  end

  # POST /project_tasks
  # POST /project_tasks.xml
  def create
    @project_task = ProjectTask.new(params[:project_task])

    respond_to do |format|
      if developer?
        if @project_task.save
          flash[:notice] = 'ProjectTask was successfully created.'
          format.html { redirect_to(@project_task) }
          format.xml  { render :xml => @project_task, :status => :created, :location => @project_task }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @project_task.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # PUT /project_tasks/1
  # PUT /project_tasks/1.xml
  def update
    @project_task = ProjectTask.find(params[:id])

    respond_to do |format|
      if developer?
        if @project_task.update_attributes(params[:project_task])
          flash[:notice] = 'ProjectTask was successfully updated.'
          format.html { redirect_to(@project_task) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @project_task.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # DELETE /project_tasks/1
  # DELETE /project_tasks/1.xml
  def destroy
    @project_task = ProjectTask.find(params[:id])

    respond_to do |format|
      if developer?
        @project_task.destroy
        format.html { redirect_to(project_tasks_url) }
        format.xml  { head :ok }
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end
end
