class ProjectMembersController < ApplicationController
  
  # GET /project_members
  # GET /project_members.xml
  def index
    @project_members = ProjectMember.find(:all,:conditions => [
      "project_id = ? and active = 1", 
      params[:project_id]
      ])
    @project = Project.find(params[:project_id]);
    @project_members = @project_members.sort_by {|pm| pm.user.last_name}
    respond_to do |format|
      format.html do
        @project_members_ids = @project_members.map {|pm| pm.user.id}
        @project_non_members = User.find(:all).select {|u| !@project_members_ids.include? u.id }
        @project_non_members = @project_non_members.sort_by {|u| u.last_name}
      end
      format.xml  { render :xml => @project_members }
    end
  end

  # GET /project_members/1
  # GET /project_members/1.xml
  def show
    @project_member = ProjectMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_member }
    end
  end

  # GET /project_members/new
  # GET /project_members/new.xml
  def new
    @project_member = ProjectMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_member }
    end
  end

  # GET /project_members/1/edit
  def edit
    @project_member = ProjectMember.find(params[:id])
  end

  # POST /project_members
  # POST /project_members.xml
  def create
    respond_to do |format|
      if developer?
        format.html do 
          @project = Project.find(params[:project_members][:project_id])
          success = true
          if params[:users]
            params[:users].each do |u|
              @project_member = ProjectMember.find(:first, :conditions => ["user_id = ? and project_id = ?", u, @project.id])
              if @project_member
                @project_member.active = true;
              else
                @project_member = ProjectMember.new({:user_id => u, :project_id => @project.id})
              end
              if !@project_member.save
                success = false              
              end
            end  
            if success
              flash[:notice] = "#{@project_member.user.full_name} is assigned to project #{@project.name}"
            else
              flash[:error] = "Could not assign project membership"
            end
          end
            redirect_to project_project_members_url(@project)
        end
        format.xml do
          @project_member = ProjectMember.new(params[:project_member])
          if @project_member.save
            flash[:notice] = 'Project Member was successfully created.'
            render :xml => @project_member, :status => :created, :location => @project_member
        
          else
            render :xml => @project_member.errors, :status => :unprocessable_entity
          end
        end
      else
          format.xml {render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # PUT /project_members/1
  # PUT /project_members/1.xml
  def update
    @project_member = ProjectMember.find(params[:id])
    respond_to do |format|
      if developer?
        if @project_member.update_attributes(params[:project_member])
          #flash[:notice] = 'ProjectMember was successfully updated.'
          format.html { redirect_to project_project_members_url(@project_member.project)  }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @project_member.errors, :status => :unprocessable_entity }
        end
      else
        format.xml { render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end

  # DELETE /project_members/1
  # DELETE /project_members/1.xml
  def destroy
    @project_member = ProjectMember.find(params[:id])
    project = @project_member.project

    respond_to do |format|
      if developer?
        @project_member.active = false
        @project_member.save
        format.html { redirect_to(project_project_members_url(project)) }
        format.xml  { head :ok }
      else
        format.xml {render :xml => XML_ERRORS[:not_authorized]}
      end
    end
  end
protected
  def init
    @current_subtab = "Members"
  end
end
