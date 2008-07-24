class MeetingParticipantsController < ApplicationController
  # GET /meeting_participants
  # GET /meeting_participants.xml
  def index
    @meeting_participants = MeetingParticipant.find(:all,
      :conditions => [
        "meeting_id = ?", 
        params[:meeting_id]
        ])
    
    @meeting_participants = @meeting_participants.sort_by {|mp| mp.user.last_name}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @meeting_participants }
    end
  end

  # GET /meeting_participants/1
  # GET /meeting_participants/1.xml
  def show
    @meeting_participant = MeetingParticipant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meeting_participant }
    end
  end

  # GET /meeting_participants/new
  # GET /meeting_participants/new.xml
  def new
    @meeting_participant = MeetingParticipant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meeting_participant }
    end
  end

  # GET /meeting_participants/1/edit
  def edit
    @meeting_participant = MeetingParticipant.find(params[:id])
  end

  # POST /meeting_participants
  # POST /meeting_participants.xml
  def create
    @meeting_participant = MeetingParticipant.new(params[:meeting_participant])

    respond_to do |format|
      if developer?
        if @meeting_participant.save
          flash[:notice] = 'MeetingParticipant was successfully created.'
          format.html { redirect_to(@meeting_participant) }
          format.xml  { render :xml => @meeting_participant, :status => :created, :location => @meeting_participant }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @meeting_participant.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # PUT /meeting_participants/1
  # PUT /meeting_participants/1.xml
  def update
    @meeting_participant = MeetingParticipant.find(params[:id])

    respond_to do |format|
      if developer?
        if @meeting_participant.update_attributes(params[:meeting_participant])
          flash[:notice] = 'MeetingParticipant was successfully updated.'
          format.html { redirect_to(@meeting_participant) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @meeting_participant.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # DELETE /meeting_participants/1
  # DELETE /meeting_participants/1.xml
  def destroy
    @meeting_participant = MeetingParticipant.find(params[:id])

    respond_to do |format|
      if developer?
        @meeting_participant.destroy
        format.html { redirect_to(meeting_participants_url) }
        format.xml  { head :ok }
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end
end
