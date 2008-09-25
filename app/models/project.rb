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
    self.iterations.select {|i| i.current?}.sort_by(&:start_date).first
  end
  
  def current_iteration_resource
    current_iteration.id rescue nil
  end

  def copy_incomplete_stories_to_current_iteration
    ci = current_iteration
    if ci && !ci.old_stories_added?
      old_incomplete_stories = self.stories.select {|story| story.iteration != ci && !story.completed} 
      stories_to_move = old_incomplete_stories.select {|story| story.iteration.end_date < Date.today}
      
      stories_to_move.each do |story|
        story_hash = Hash.from_xml(story.to_xml)["story"].merge({"iteration_id" => ci.id})
        story_copy = Story.new(story_hash)
        story_copy.save
        story.agile_tasks.select {|t| t.completion_date == nil}.each do |task|
          task.story_id = story_copy.id
          task.save
        end
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

  def velocity
    data = []
    all_iters = self.iterations.reverse
    all_iters.each do |iteration|
      iter_length = (iteration.end_date - iteration.start_date).to_i
      normalized_units = iteration.work_units_real/(iter_length/self.iteration_length) rescue iteration.work_units_real
      data << {:iteration_id => iteration.id, :iteration_length => iter_length, :start_date => iteration.start_date, :units => normalized_units}
    end
    data
  end
  
end
