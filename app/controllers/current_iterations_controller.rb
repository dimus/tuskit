class CurrentIterationsController < ApplicationController
  layout "user"
  
  # GET /active_projects.xml
  def index
    @projects = current_user.projects.find(:all).find_all {|p| p.current_iteration}
    @iteration_ids = @projects.map {|p| p.current_iteration().id}
    @iterations = Iteration.find(:all, 
    :conditions => ["id in (?)", @iteration_ids])
    @iterations = @iterations.sort {|x,y| y.daily_load <=> x.daily_load}
    @iterations.each do |iteration|
      iteration.project.copy_incomplete_stories_to_current_iteration
    end
    respond_to do |format|
      format.html {
        @all_projects = Project.find(:all)
      }
      format.xml  { render :xml => @iterations.to_xml(:methods => [:daily_load,:work_units_real, :agile_tasks_number]) }
    end
  end
end
