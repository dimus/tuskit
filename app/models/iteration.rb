require 'task'
class Iteration < ActiveRecord::Base
  belongs_to :project
  has_many :meetings
  has_many :stories, :order => "created_at desc"
  has_many :agile_tasks, :through => :stories
  
  validates_presence_of :start_date
  validates_presence_of :end_date
  
  def stories_prepare
    unfinished = []
    finished = []
    maybe_finished = []
    self.stories.each do |story|
      completed_all_tasks = !story.agile_tasks.empty? && story.agile_tasks.select {|task| task.completion_date == nil}.empty?
      if story.completed
        if !completed_all_tasks
          story.completed = false
          story.save
        end
      end
      if story.completed
        finished << story
      elsif completed_all_tasks
        maybe_finished << story
      else
        unfinished << story  
      end
    end
    maybe_finished.sort_by(&:updated_at).reverse + unfinished.sort_by(&:updated_at).reverse + finished.sort_by(&:updated_at).reverse
  end
  
  def work_units_real
    #count w.u. for completed tasks only
    completed_stories = self.stories.select {|s| s.completed?}
    completed_stories.inject(0) {|res, data| res += data.work_units_est}
  end

  def work_units_planned
    stories.inject(0) {|res, data| res+= data.work_units_est}
  end
  
  def agile_tasks_number
    agile_tasks.size
  end
  
  def complete_tasks
    #finished tasks
    agile_tasks.find(:all, 
      :conditions=>"completion_date is not null", 
      :order=>"completion_date desc, updated_at desc")
  end

  def daily_load
    wu_todo= work_units - work_units_real
    if wu_todo > 0
      return wu_todo/days_left
    else
      return 0
    end
  end
  
  def current?
    today = Date.today
    start_date <= today && end_date >= today  
  end
  
  def days_left
    #amount of days left to the end of the iteration
    end_date.-(Date.today).to_i + 1
  end
  
end