class ReportsController < ApplicationController
  before_filter :find_project

  def index
    page = params[:page] || 1
    query = "select id, start_date, end_date from iterations where project_id = #{@project.id} and end_date < '#{Date.today.to_s}' order by start_date desc" 
    @reports = Iteration.paginate_by_sql(query, :page => page)
    respond_to do |format|
      format.html
      format.xml { render :xml => @reports.to_xml }
    end
  end

  def show
    @report = Iteration.find(params[:id])
    @milestone = Milestone.find(:first,:conditions => ["project_id = ? and completion_date is null or completion_date > ?", @project.id, Date.today.to_s], :order => "completion_date, id")
    @milestone_stories =  @milestone.stories.select {|s| s.iteration == @report && !s.completion_date.blank? }
    respond_to do |format|
      format.html
      format.xml { render :xml => @r }
    end
  end

protected
  def init
    @current_subtab = "Reports"
  end

  def find_project
    project_id = params[:project_id]
    @project = project_id ? Project.find(project_id) : nil
  end
end
