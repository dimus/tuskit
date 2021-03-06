class ReportsController < ApplicationController
  before_filter :find_project

  def index
    page = params[:page] || 1
    query = "select id, start_date, end_date from iterations where project_id = #{@project.id} and start_date < '#{Date.today.to_s}' order by start_date desc" 
    @reports = Iteration.paginate_by_sql(query, :page => page)
    respond_to do |format|
      format.html
      format.xml { render :xml => @reports.to_xml }
    end
  end

  def show
    @report = Iteration.find(params[:id])
    @milestone = @report.milestone 
    @milestone_stories =  @milestone.stories.select {|s| s.iteration == @report && !s.completion_date.blank? } rescue nil
    @report_next = @report.next
    @report_previous = @report.previous
    respond_to do |format|
      format.html
      format.xml { render :xml => @report }
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
