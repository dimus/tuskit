class Task < ActiveRecord::Base
end

class AgileTask < Task
  belongs_to :story
  has_many :task_owners, :include => :user, :dependent => :destroy
  
  validates_presence_of :story_id
  validates_presence_of :name
  
  def iteration
    story.iteration
  end
  
  def project
    iteration.project
  end
  
  def tracker
    project.tracker
  end

  def owners
    self.task_owners.map {|t| User.find(t.user_id)}
  end

  def validate 
    if self.completion_date != nil 
      if self.task_units.to_f == 0.0
        errors.add_to_base("Please add Task Units before completing this task.")
      end
      if self.id && TaskOwner.find_by_agile_task_id(self.id).blank?
        errors.add_to_base("Please add Task Owners before completing this task.")
      end
    end
  end
end

class ProjectTask < Task
  belongs_to :project
  
  validates_presence_of :project_id
  
  def tracker
    project.tracker
  end
end

class TrackerTask < Task
  belongs_to :tracker
  
  validates_presence_of :tracker_id
end
