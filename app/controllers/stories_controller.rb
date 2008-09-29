class StoriesController < ApplicationController
  layout "user"
  # GET /stories
  # GET /stories.xml
  def index
    @iteration = Iteration.find(params[:iteration_id])
    @meetings = @iteration.meetings.sort_by(&:meeting_date).reverse
    @project = @iteration.project
    @project.copy_incomplete_stories_to_current_iteration
    @stories = @iteration.stories_prepare
    all_iters = @project.iterations.reverse
    iter_index = all_iters.index @iteration
    @previous_iteration = (iter_index > 0)  ? all_iters[iter_index - 1] : nil
    @next_iteration = (iter_index != (iter_index.size - 1)) ? all_iters[iter_index + 1] : nil
    @collapse_iteration = session["collapse_iteration_" + @iteration.id.to_s] ? true : false
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.xml
  def new
    @iteration = Iteration.find(params[:iteration_id])
    @project = @iteration.project
    @story = Story.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
    @iteration = @story.iteration
    @project = @iteration.project
  end

  # POST /stories
  # POST /stories.xml
  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if developer?
        if @story.save
          format.html { redirect_to(iteration_stories_url(@story.iteration, :anchor => "story_" + @story.id.to_s)) }
          format.xml  { render :xml => @story, :status => :created, :location => @story }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml =>  XML_ERRORS[:not_authorized]}
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if developer?
        if @story.update_attributes(params[:story])
          format.html { redirect_to(iteration_stories_url(@story.iteration, :anchor => "story_" + @story.id.to_s)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id])
    begin
      respond_to do |format|
        if developer?
          @story.destroy
          format.html { redirect_to(iteration_stories_url(@story.iteration)) }
          format.xml  { head :ok }
        else
          format.xml { render :xml => XML_ERRORS[:not_authorized]}
        end
      end
    rescue ActiveRecord::StatementInvalid
      respond_to do |format|
        format.xml {render :xml => XML_ERRORS[:foreign_key_problem]}
      end 
    end
  end
protected
  def init
    @current_subtab = "Iterations"
  end
end
