class ReportsController < ApplicationController
  
  def index
    page = params[:page] || 1 rescue 1
    @project = Project.find(params[:project_id])
    @reports = Report.find_by_sql(["select r.* from reports r join iterations i on i.id = r.iteration_id where i.project_id = ? and i.end_date < ? order by i.start_date desc", @project.id, Date.today])
    respond_to do |format|
      format.html
      format.xml { render :xml => @reports.map {|report| report.report = Hash.from_xml(report.report)['hash'].to_xml; report} }
    end
  end

  def show
    @project = Project.find(params[:project_id])
    @report = Report.find(params[:id])
    @r = Hash.from_xml(@report.report)['hash']
    respond_to do |format|
      format.html
      format.xml { render :xml => @r }
    end
  end

protected
  def init
    @current_subtab = "Reports"
  end
end
