class TrackerTasksController < ApplicationController
  # GET /tracker_tasks
  # GET /tracker_tasks.xml
  def index
    @tracker_tasks = TrackerTask.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tracker_tasks }
    end
  end

  # GET /tracker_tasks/1
  # GET /tracker_tasks/1.xml
  def show
    @tracker_task = TrackerTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tracker_task }
    end
  end

  # GET /tracker_tasks/new
  # GET /tracker_tasks/new.xml
  def new
    @tracker_task = TrackerTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tracker_task }
    end
  end

  # GET /tracker_tasks/1/edit
  def edit
    @tracker_task = TrackerTask.find(params[:id])
  end

  # POST /tracker_tasks
  # POST /tracker_tasks.xml
  def create
    @tracker_task = TrackerTask.new(params[:tracker_task])

    respond_to do |format|
      if developer?
        if @tracker_task.save
          flash[:notice] = 'TrackerTask was successfully created.'
          format.html { redirect_to(@tracker_task) }
          format.xml  { render :xml => @tracker_task, :status => :created, :location => @tracker_task }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @tracker_task.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # PUT /tracker_tasks/1
  # PUT /tracker_tasks/1.xml
  def update
    @tracker_task = TrackerTask.find(params[:id])

    respond_to do |format|
      if developer?
        if @tracker_task.update_attributes(params[:tracker_task])
          flash[:notice] = 'TrackerTask was successfully updated.'
          format.html { redirect_to(@tracker_task) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @tracker_task.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # DELETE /tracker_tasks/1
  # DELETE /tracker_tasks/1.xml
  def destroy
    @tracker_task = TrackerTask.find(params[:id])

    respond_to do |format|
      if developer?
        @tracker_task.destroy
        format.html { redirect_to(tracker_tasks_url) }
        format.xml  { head :ok }
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end
end
