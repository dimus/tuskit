class UsersController < ApplicationController
  layout "user"
  
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def index
    @users = User.find(:all, :order=>'last_name')
    usrs = prepare_users(@users)
    respond_to do |format|
      format.html {
        @users = @users.sort_by(&:last_name)
      }
      format.xml  do 
        render :xml => usrs.to_xml(:include => [:groups])
      end
    end
  end
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    usr = prepare_user(@user);
    respond_to do |format|
      format.xml  { render :xml => usr.to_xml }
    end
  end

  
# POST /users.xml
 def create
   if admin?
      @user = User.new(params[:user])
      @user.save!
      params[:groups].each do |group_id|
           Membership.create!(:user => @user, :group => Group.find(group_id.to_i));
      end if params[:groups]
      respond_to do |format| 
        format.html do 
          flash[:notice] = "New User '#{@user.full_name}' had been created " 
          redirect_to users_url 
        end 
        #head :created
        format.xml  { render :xml => prepare_user(@user).to_xml(), :status => :created } 
      end
    else
      respond_to do |format|
        format.html {render :action => 'new'}
        format.xml do
          render  :xml => '<?xml version="1.0" ?><errors><error>Not Authorized</error></errors>', 
                  :status => 200
        end
      end
    end 
  rescue ActiveRecord::RecordInvalid 
    respond_to do |format| 
      format.html { render :action => 'new' } 
      format.xml do 
        if !@user.errors.empty? 
          render  :xml => @user.errors.to_xml_full,
                  :status => 200
        else 
          head(400) #bad request
        end 
      end 
    end  
  end
  
  # GET /projects/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    Group.find(:all).each do |group|
      groups = params[:groups].map {|i| i.to_i} rescue []
      membership = Membership.find(:first, :conditions => ["group_id = ? and user_id = ?", group.id, @user.id])
      g_checked = groups.include? group.id
      Membership.create(:group  =>  group, :user => @user) if !membership && g_checked
      membership.destroy if membership && !g_checked
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html do
          flash[:notice] = "User #{@user.full_name} was successfully updated."
          redirect_to users_url
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end
  
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    user_full_name = @user.full_name
    begin
      if admin?
        @user.destroy
        respond_to do |format|
          format.html do
            flash[:notice] = "User '#{user_full_name}' was successfully deleted."
            redirect_to users_url
          end
          format.xml  do 
            head(200)
          end
        end
      else
        respond_to do |format|
          format.xml do 
            render  :xml => XML_ERRORS[:not_authorized], 
                    :status => 200
          end
        end
      end
    rescue ActiveRecord::StatementInvalid
      respond_to do |format|
        format.xml { render  :xml => XML_ERRORS[:foreign_key_problem] }
      end
    end
  end

  private
  
  
  def prepare_users(users_list)
    retval = []
    users_list.each do |u|
      retval << prepare_user(u)
    end
    retval
  end
  
  def prepare_user(a_user)
    usr = {
      :id=> a_user.id,
      :login => a_user.login,
      :first_name => a_user.first_name,
      :last_name => a_user.last_name,
      :phone  => a_user.phone,
      :email  => a_user.email,
      :groups => []
    }
    a_user.groups.each do |g|
      usr[:groups] << {:id => g.id, :name => g.name}
    end
    usr
  end

end
