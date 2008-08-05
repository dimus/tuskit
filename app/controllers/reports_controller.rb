class ReportsController < ApplicationController
  layout 'user'
  def index
    @project = Project.find(params[:project_id])
  end

protected
  def init
    @current_subtab = "Reports"
  end
end
