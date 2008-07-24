class TaskOwner < ActiveRecord::Base
  belongs_to :agile_task
  belongs_to :user
  
  validates_uniqueness_of :user_id , :scope => :agile_task_id, :message => 'The user already owns this task'
  validates_presence_of :user_id, :agile_task_id
  
end
