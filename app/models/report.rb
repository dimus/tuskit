require 'date_helpers'
class Report < ActiveRecord::Base
  extend DateHelpers
  belongs_to :iteration

  def recipients
    project = self.iteration
    project.project_members.select {|pm| pm.send_iteration_report && !pm.email.strip.blank?}.map {|pm| pm.user}
  end
end
