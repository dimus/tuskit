class Project < ActiveRecord::Base

  acts_as_tree :order => "name"
  belongs_to :tracker
  has_many :project_members, :conditions => "active = 1"
  has_many :users, :through => :project_members
  has_many :iterations, :order => "start_date desc"
  has_many :stories, :through => :iterations
  has_many :project_tasks
  
  validates_presence_of :name
 
  def reports
    self.iterations.select {|i| i.end_date < Date.today}.map {|i| i.report || Report.create(:iteration => i, :report => Report.generate(i))}
  end

  def current_iteration 
    self.iterations.select {|i| i.current?}.sort_by(&:start_date).last  
  end
  
  def current_iteration_resource
    current_iteration.id rescue nil
  end

  def move_incomplete_stories_to_current_iteration
    ci = current_iteration
    if ci && !ci.old_stories_added?
      old_incomplete_stories = self.stories.select {|story| story.iteration != ci && !story.completed} 
      stories_to_move = old_incomplete_stories.select {|story| story.iteration.end_date < Date.today}
      
      stories_to_move.each do |story|
        story.iteration_id = ci.id
        story.save
      end
      
      if old_incomplete_stories.size == stories_to_move.size
        ci.old_stories_added = true
        ci.save
      end
    
    end
  end
  
  def work_units_real
    wu=0
    iterations.each do |iteration|
      wu += iteration.work_units_real
    end
    wu
  end

  def developers
    developers = []
    dev_group = Group.find_by_name('developer')
    
    project_members.each do |pm|
      groups = pm.user.memberships.map {|m| m.group}
      developers << pm if groups.include? dev_group 
    end
    developers
  end
  
end
