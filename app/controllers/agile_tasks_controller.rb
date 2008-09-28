class AgileTasksController < ApplicationController
  layout "user"

  # GET /agile_tasks
  # GET /agile_tasks.xml
  def index
    @agile_tasks = AgileTask.find(:all)

    respond_to do |format|
      #format.html # index.html.erb
      format.xml  { render :xml => @agile_tasks }
    end
  end

  # GET /agile_tasks/1
  # GET /agile_tasks/1.xml
  def show
    @agile_task = AgileTask.find(params[:id])

    respond_to do |format|
      #format.html # show.html.erb
      format.xml  { render :xml => @agile_task }
    end
  end

  # GET /agile_tasks/new
  # GET /agile_tasks/new.xml
  def new
    @story = Story.find(params[:story_id])
    @agile_task = AgileTask.new
    #@agile_task.story = @story
    @project = @story.iteration.project

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @agile_task }
    end
  end

  # GET /agile_tasks/1/edit
  def edit
    @agile_task = AgileTask.find(params[:id], :include => :task_owners)
    @story = Story.find(params[:story_id])
    @iteration = @story.iteration  
    @project = @iteration.project
  end

  # POST /agile_tasks
  # POST /agile_tasks.xml
  def create
    @agile_task = AgileTask.new(params[:agile_task])

    respond_to do |format|
      if developer?
        @agile_task.created_by = @agile_task.updated_by = current_user.login
        @agile_task.completion_date = Date.today if params[:task_completed].to_i == 1
        if @agile_task.save
          params[:user_ids].each do |uid|
               TaskOwner.create(:user => User.find(uid.to_i), :agile_task => @agile_task, :created_by => current_user.login, :updated_by => current_user.login);
          end if params[:user_ids]
          flash[:notice] = "Task '#{@agile_task.name}' was successfully created."
          format.html { redirect_to(iteration_stories_url(@agile_task.story.iteration_id, :anchor => "task_" + @agile_task.id.to_s)) }
          format.xml  { render :xml => @agile_task, :status => :created, :location => @agile_task }
        else
          format.html do 
            @story = Story.find(@agile_task.story_id)
            @iteration = Iteration.find(@story.iteration_id)
            @project = @iteration.project
            render :action => "new" 
          end
          format.xml  { render :xml => @agile_task.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # PUT /agile_tasks/1
  # PUT /agile_tasks/1.xml
  def update
    @agile_task = AgileTask.find(params[:id])

    respond_to do |format|
      if developer?
        @agile_task.updated_by = current_user.login
        @agile_task.completion_date = Date.today if params[:task_completed].to_i == 1
        if params[:task_not_completed].to_i == 1
          @agile_task.completion_date = nil
          date_keys = params[:agile_task].keys.select {|k| k.match(/completion_date/)}
          date_keys.each {|k| params[:agile_task].delete(k)}
        end
        param_users = (params[:user_ids].map {|i| i.to_i} rescue []).to_set
        task_users = (@agile_task.task_owners.map {|i| i.user_id}).to_set
        (param_users - task_users).each {|uid| TaskOwner.create(:user => User.find(uid), :agile_task => @agile_task)}
        (task_users - param_users).each {|uid| TaskOwner.find(:first, :conditions => ["agile_task_id = ? and user_id = ?", @agile_task.id, uid]).destroy rescue nil }


        if @agile_task.update_attributes(params[:agile_task])
          story = Story.find(@agile_task.story_id)
          iteration = story.iteration
          flash[:notice] = "Task '#{@agile_task.name}' was successfully updated."
          format.html { redirect_to(iteration_stories_url(iteration,:anchor => "task_" + @agile_task.id.to_s)) }
          format.xml  { head :ok }
        else
          format.html do 
            @agile_task.reload
            @story = Story.find(@agile_task.story_id)
            @iteration = Iteration.find(@story.iteration_id)
            @project = @iteration.project
            render :action => "edit"
          end 
          format.xml  { render :xml => @agile_task.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # DELETE /agile_tasks/1
  # DELETE /agile_tasks/1.xml
  def destroy
    @agile_task = AgileTask.find(params[:id])
    story = Story.find(params[:story_id])

    respond_to do |format|
      if developer?
        @agile_task.destroy
        format.html { redirect_to(iteration_stories_url(story.iteration_id)) }
        format.xml  { head :ok }
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end
protected
  def init
    @current_subtab = "Iterations"
  end
end
