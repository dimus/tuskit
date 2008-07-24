class Story < ActiveRecord::Base
  belongs_to :iteration
  has_many :agile_tasks
  
  validates_presence_of :name
  
  def project
    iteration.project
  end

  def agile_tasks_sorted
    unowned_bugs = []
    unowned = []
    owned = []
    completed = []

    self.agile_tasks.each do |task|
      if task.completion_date
        completed << task
      elsif task.task_owners.size > 0
        owned << task
      elsif task.bug?
        unowned_bugs << task
      else
        unowned << task
      end
    end
    owned.sort_by(&:updated_at).reverse + unowned_bugs.sort_by(&:updated_at).reverse + unowned.sort_by(&:updated_at).reverse + completed.sort_by(&:updated_at).reverse
  end
  
end
