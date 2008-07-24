class TaskOwnersController < ApplicationController
  # GET /task_owners
  # GET /task_owners.xml
  def index
    @task_owners = TaskOwner.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @task_owners }
    end
  end

  # GET /task_owners/1
  # GET /task_owners/1.xml
  def show
    @task_owner = TaskOwner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task_owner }
    end
  end

  # GET /task_owners/new
  # GET /task_owners/new.xml
  def new
    @task_owner = TaskOwner.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task_owner }
    end
  end

  # GET /task_owners/1/edit
  def edit
    @task_owner = TaskOwner.find(params[:id])
  end

  # POST /task_owners
  # POST /task_owners.xml
  def create
    @task_owner = TaskOwner.new(params[:task_owner])

    respond_to do |format|
      if developer?
        if @task_owner.save
          flash[:notice] = 'TaskOwner was successfully created.'
          format.html { redirect_to(@task_owner) }
          format.xml  { render :xml => @task_owner, :status => :created, :location => @task_owner }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @task_owner.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # PUT /task_owners/1
  # PUT /task_owners/1.xml
  def update
    @task_owner = TaskOwner.find(params[:id])

    respond_to do |format|
      if developer?
        if @task_owner.update_attributes(params[:task_owner])
          flash[:notice] = 'TaskOwner was successfully updated.'
          format.html { redirect_to(@task_owner) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @task_owner.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized] }
      end
    end
  end

  # DELETE /task_owners/1
  # DELETE /task_owners/1.xml
  def destroy
    @task_owner = TaskOwner.find(params[:id])

    respond_to do |format|
      if developer?
        @task_owner.destroy
        format.html { redirect_to(task_owners_url) }
        format.xml  { head :ok }
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end
end
