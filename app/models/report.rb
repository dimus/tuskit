require 'date_helpers'
class Report < ActiveRecord::Base
  extend DateHelpers
  belongs_to :iteration
  
  def self.generate(an_iteration)
    i = an_iteration
    report = {}
    report[:project] = i.project.name
    report[:iteration] = dates_interval(i.start_date,i.end_date)
    report[:objectives] = i.objectives
    report[:work_units_planned] = i.work_units_planned
    report[:work_units_real] = i.work_units_real
    report[:stories] = []
    i.stories.sort_by(&:updated_at).each do |story|
      s={}
      s[:name] = story.name
      s[:work_units_est] = story.work_units_est
      s[:completed] = story.completed
      s[:updated_at] = story.updated_at
      s[:created_at] = story.created_at
      tasks = []
      story.agile_tasks.sort_by(&:completion_date).each do |task|
        t={}
        t[:name] = task.name
        t[:completion_date] = task.completion_date
        t[:bug] = task.bug
        t[:updated_at] = task.updated_at
        t[:created_at] = task.created_at
        owners = []
        task.task_owners.each do |owner|
          owners << {:name => owner.user.full_name}
        end
        t[:owners] = owners unless owners.blank?
        tasks << t
      end
      s[:tasks] = tasks unless tasks.blank?
      report[:stories] << s
    end
    report[:meetings] = []
    i.meetings.sort_by(&:meeting_date).each do |meeting|
      m = {}
      m[:name] = meeting.name
      m[:meeting_date] = meeting.meeting_date
      m[:length] = meeting.length
      m[:notes] = meeting.notes
      report[:meetings] << m
    end
    report.to_xml
  end
end
