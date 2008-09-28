class GroupsController < ApplicationController
  before_filter :find_user, :only => [:index]
  # GET /groups
  # GET /groups.xml
  def index
    if @user
      @groups = @user.groups
    else
      @groups = Group.find(:all)
    end
    
    respond_to do |format|
      format.xml  { render :xml => @groups.to_xml }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show

    @group = Group.find(params[:id])
   
    
    respond_to do |format|
      format.xml  { render :xml => @group.to_xml }
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1;edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.xml  { head :created, :location => group_url(@group) }
      else
        format.xml  { render :xml => @group.errors.to_xml }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @group.errors.to_xml }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.xml  { head :ok }
    end
  end

private
  def find_user
    @user = User.find params[:user_id] rescue nil
  end

end
