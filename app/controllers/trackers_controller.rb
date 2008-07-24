class TrackersController < ApplicationController
  # GET /trackers
  # GET /trackers.xml
  def index
    @trackers = Tracker.find(:all)

    respond_to do |format|
      format.html # index.erb
      format.xml  { render :xml => @trackers.to_xml }
    end
  end

  # GET /trackers/1
  # GET /trackers/1.xml
  def show
    @tracker = Tracker.find(params[:id])

    respond_to do |format|
      format.html # show.erb
      format.xml  { render :xml => @tracker.to_xml }
    end
  end

  # GET /trackers/new
  def new
    @tracker = Tracker.new
  end

  # GET /trackers/1/edit
  def edit
    @tracker = Tracker.find(params[:id])
  end

  # POST /trackers
  # POST /trackers.xml
  def create
    @tracker = Tracker.new(params[:tracker])
    respond_to do |format|
      if developer?
        if @tracker.save
          flash[:notice] = 'Tracker was successfully created.'
          format.html { redirect_to tracker_url(@tracker) }
          format.xml  { head :created, :location => tracker_url(@tracker) }
        else
          format.html { render :action => "new" }
          format.xml  do
              render :xml => @tracker.errors.to_xml 
              render :xml => XML_ERRORS[:not_authorized]
          end
        end
      else
        format.html do
          flash[:error] = 'Not authorized to create Tracker record'
          redirect_to trackers_url
        end
        format.xml {render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # PUT /trackers/1
  # PUT /trackers/1.xml
  def update
    @tracker = Tracker.find(params[:id])

    respond_to do |format|
      if developer?
        if @tracker.update_attributes(params[:tracker])
          flash[:notice] = 'Tracker was successfully updated.'
          format.html { redirect_to tracker_url(@tracker) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @tracker.errors.to_xml }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # DELETE /trackers/1
  # DELETE /trackers/1.xml
  def destroy
    begin
      @tracker = Tracker.find(params[:id])
      respond_to do |format|
        if developer?
          @tracker.destroy
          format.html { redirect_to trackers_url }
          format.xml  { head :ok }
        else
          format.xml { render :xml => XML_ERRORS[:not_authorized]}
        end
      end
    rescue ActiveRecord::StatementInvalid 
      respond_to do |format| 
        flash.now[:error] = 'Cannot delete record because it is in use'
        format.html { render :action => 'edit' } 
        format.xml do 
            render  :xml => XML_ERRORS[:foreign_key_problem], 
                    :status => 200
        end 
      end
    end
  end

end
