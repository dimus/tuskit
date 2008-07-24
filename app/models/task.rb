class Task < ActiveRecord::Base
end

class AgileTask < Task
  belongs_to :story
  has_many :task_owners
  
  validates_presence_of :story_id
  
  def iteration
    story.iteration
  end
  
  def project
    iteration.project
  end
  
  def tracker
    project.tracker
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
