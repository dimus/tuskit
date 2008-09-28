class MeetingsController < ApplicationController
  layout "user"
  # GET /meetings
  # GET /meetings.xml
  def index
    @meetings = Meeting.find(:all,
      :order => 'meeting_date desc', 
      :conditions => ["iteration_id = ?", params[:iteration_id]])

    respond_to do |format|
      format.xml  { render :xml => @meetings }
    end
  end

  # GET /meetings/1
  # GET /meetings/1.xml
  def show
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.xml
  def new
    @iteration = Iteration.find(params[:iteration_id])
    @project = @iteration.project
    @meeting = Meeting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @iteration = Iteration.find(params[:iteration_id])
    @project = @iteration.project
    @meeting = Meeting.find(params[:id])
  end

  # POST /meetings
  # POST /meetings.xml
  def create
    @meeting = Meeting.new(params[:meeting])
    @iteration = Iteration.find(params[:meeting][:iteration_id])
    respond_to do |format|
      if developer?
        if @meeting.save
          flash[:notice] = 'Meeting was successfully created.'
          format.html do 
            
            params[:users].each do |uid|
              user = User.find(uid)
              MeetingParticipant.create(:user => user, :meeting => @meeting)
            end if params.key? :users
            
            redirect_to(iteration_stories_url(@iteration))
          end
          format.xml  { render :xml => @meeting, :status => :created, :location => @meeting }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # PUT /meetings/1
  # PUT /meetings/1.xml
  def update
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      if developer?
        #take care of meeting participants
        param_users = (params[:users].map {|i| i.to_i} rescue []).to_set
        meeting_users = (@meeting.meeting_participants.map {|mp| mp.user.id}).to_set
        (param_users - meeting_users).each {|uid| MeetingParticipant.create(:user => User.find(uid), :meeting => @meeting)}
        (meeting_users - param_users).each {|uid| MeetingParticipant.find(:first, :conditions => ["meeting_id = ? and user_id = ?", @meeting.id, uid]).destroy rescue nil}

        if @meeting.update_attributes(params[:meeting])
          flash[:notice] = 'Meeting was successfully updated.'
          format.html { redirect_to(iteration_stories_url(@meeting.iteration)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.xml
  def destroy
    @meeting = Meeting.find(params[:id])
    @iteration = @meeting.iteration
    begin
      respond_to do |format|
        @meeting.destroy
        format.html { redirect_to(iteration_stories_url(@iteration)) }
        format.xml  { head :ok }
      end
    rescue ActiveRecord::StatementInvalid 
      respond_to do |format|
        format.xml { render :xml => XML_ERRORS[:foreign_key_problem] }
      end
    end
  end
protected
  def init
    @current_subtab = "Iterations"
  end
end
