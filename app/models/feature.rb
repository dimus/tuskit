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
    self.stories.inject(0) {|res, s| res += s.work_units_est }
  end
end
