class MembershipsController < ApplicationController
  skip_before_filter :login_required, :only=>[:admin_exists]
  before_filter :find_user, :only => [:index]
  # GET /memberships
  # GET /memberships.xml
  def index
    
    if @user
      @memberships = @user.memberships
    else
      @memberships = Membership.find(:all)
    end    

    respond_to do |format|
      format.xml  { render :xml => @memberships.to_xml }
    end
  end

  # GET /memberships/1
  # GET /memberships/1.xml
  def show
    @membership = Membership.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @membership.to_xml }
    end
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1;edit
  def edit
    @membership = Membership.find(params[:id])
  end

  # POST /memberships
  # POST /memberships.xml
  def create
    @membership = Membership.new(params[:membership])

    respond_to do |format|
      if @membership.save
        flash[:notice] = 'Membership was successfully created.'
        format.xml  { head :created, :location => membership_url(@membership) }
      else
        format.xml  { render :xml => @membership.errors.to_xml }
      end
    end
  end

  # PUT /memberships/1
  # PUT /memberships/1.xml
  def update
    @membership = Membership.find(params[:id])

    respond_to do |format|
      if @membership.update_attributes(params[:membership])
        flash[:notice] = 'Membership was successfully updated.'
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @membership.errors.to_xml }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.xml
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy

    respond_to do |format|
      format.xml  { head :ok }
    end
  end
  
  def admin_exists
    if Membership.find_by_group_id(Group.find_by_name("admin").id.to_i)
      render :xml => {:admin_exists => true}.to_xml
    else
      render :xml => {:admin_exists => false}.to_xml 
    end
  end

  private
    def find_user
      @user = User.find params[:user_id] rescue nil
      logger.info @user.to_yaml
    end
end
