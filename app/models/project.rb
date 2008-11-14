class Project < ActiveRecord::Base

  acts_as_tree :order => "name"
  belongs_to :tracker
  has_many :project_members, :conditions => "active = 1"
  has_many :users, :through => :project_members
  has_many :iterations, :order => "start_date desc"
  has_many :stories, :through => :iterations
  has_many :project_tasks
  has_many :milestones
  
  validates_presence_of :name
 
  def current_iteration 
    self.iterations.select {|i| i.current?}.sort_by(&:start_date).first
  end

  def future_iterations
    ci = self.current_iteration
    self.iterations.select {|i| (i.current? || i.future?) && i != ci}.sort_by(&:start_date)
  end

  def current_milestone
    self.milestones.select {|m| m.completion_date == nil }.sort_by(&:created_at).first
  end
  
  def current_iteration_resource
    current_iteration.id rescue nil
  end

  def copy_incomplete_stories_to_current_iteration
    ci = current_iteration
    if ci && !ci.old_stories_added?
      iters = self.iterations.reverse
      ci_index = iters.index ci
      if ci_index > 0
        prev_iteration = iters[ci_index - 1]
        stories_to_move = prev_iteration.stories.select {|story| !story.completed}
        stories_to_move.each do |story|
          story_copy = Story.create(:name => story.name, :work_units_est => story.work_units_est, :iteration_id => prev_iteration.id)
          story.iteration_id = ci.id
          story.save
        end
      end
      ci.old_stories_added = true
      ci.save
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
      developers << pm.user if groups.include? dev_group 
    end
    developers
  end

  def velocity
    data = []
    all_iters = self.iterations.reverse
    all_iters.each do |iteration|
      iter_length = (iteration.end_date - iteration.start_date).to_i
      length_coef = self.iteration_length && self.iteration_length > 0 ? self.iteration_length.to_f/iter_length.to_f : 1.0
      normalized_units = iteration.work_units_real * length_coef rescue iteration.work_units_real
      data << {:iteration_id => iteration.id, :iteration_length => iter_length, :start_date => iteration.start_date, :units => normalized_units}
    end
    data
  end
  
end
