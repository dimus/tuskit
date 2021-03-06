class Feature < ActiveRecord::Base
  belongs_to :milestone
  has_many :implementations
  has_many :iterations

  has_many :stories, :through => :implementations

  validates_presence_of :name
  
  def stories_prepared
    active = []
    finished = []
    unfinished = []
    for story in self.stories
      if story.completion_date
        finished << story
      elsif story.active?
        active << story
      else
        unfinished << story
      end
    end
    active + unfinished + finished.sort_by(&:completion_date)
  end

  def total_work_units
    self.stories.inject(0) {|res, s| res += s.work_units_est } || 0 rescue 0
  end

  def work_units_real(wu_date = Date.today)
    self.stories.inject(0) {|res, s| res += s.work_units_est if (s.completion_date && s.completion_date <= wu_date) } || 0 rescue 0
  end

  def all_stories_completed?
    !self.stories.blank? && self.stories.select {|story| story.completion_date == nil}.blank?
  end

  # finds the completion date of the last completed story of the feature
  def last_story_date
    self.stories.select {|story| story.completion_date}.sort_by(&:completion_date).last.completion_date.to_s rescue nil
  end

end
