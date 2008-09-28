# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout "user"
  skip_before_filter :login_required

  def index
    if current_user != :false && current_user.groups
      group_priorities  = [
        [Group.find_by_name("developer"),current_iterations_url],
        [Group.find_by_name("customer"), current_iterations_url], #not a good page, just a placeholder for now
        [Group.find_by_name("admin"), users_url]
      ]
      group_priorities.each do |gp|
        if current_user.groups.include? gp[0]
          redirect_to gp[1]
          return
        end
      end
    else
      redirect_to new_session_url
    end
  end

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      usr = session_user();    
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = {
          :value => self.current_user.remember_token,
          :expires => self.current_user.remember_token_expires_at
        }
      end
      respond_to do |format| 
        format.html do 
          redirect_back_or_default('/') 
          flash[:notice] = ["Logged in successfully"]
        end 
        format.xml  { render :xml => usr.to_xml } 
      end 
    else 
      respond_to do |format| 
        format.html {
          if User.count > 0 
            flash[:error] = ["Bad login or password"]
          else
            flash[:error] = ["Add admin user by running admin_create from scripts directory"]
          end
          render :action => 'new' 
        } 
        format.xml  { render :text => "badlogin" } 
      end 
    end       
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    respond_to do |format|
      format.html do
        flash[:notice] = "You have been logged out."
        redirect_back_or_default('/')
      end
      format.xml {render :text => 'logged_out'}
    end
  end
  
  private   
    def session_user()
      usr = {
        :id=> self.current_user.id,
        :login => self.current_user.login,
        :first_name => self.current_user.first_name,
        :last_name => self.current_user.last_name,
        :phone  => self.current_user.phone,
        :email  => self.current_user.email,
        :login_time => Time.now(),
        :groups => []
      }
      self.current_user.groups.each do |g|
        usr[:groups] << {:id => g.id, :name => g.name}
      end
      usr
    end
end
