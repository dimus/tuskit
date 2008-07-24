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
      format.html # index.erb
      format.xml  { render :xml => @groups.to_xml }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show

    @group = Group.find(params[:id])
   
    
    respond_to do |format|
      format.html # show.erb
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
        format.html { redirect_to group_url(@group) }
        format.xml  { head :created, :location => group_url(@group) }
      else
        format.html { render :action => "new" }
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
        format.html { redirect_to group_url(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
      format.html { redirect_to groups_url }
      format.xml  { head :ok }
    end
  end

private
  def find_user
    @user = User.find params[:user_id] rescue nil
  end

end