class ReportsController < ApplicationController
  layout 'user'
  def index
    page = params[:page] || 1 rescue 1
    @project = Project.find(params[:project_id])
    @reports = Report.find_by_sql(["select r.* from reports r join iterations i on i.id = r.iteration_id where i.project_id = ? and i.end_date < ? order by i.start_date desc", @project.id, Date.today])
  end

  def show
    @project = Project.find(params[:project_id])
    @report = Report.find(params[:id])
  end

protected
  def init
    @current_subtab = "Reports"
  end
end
