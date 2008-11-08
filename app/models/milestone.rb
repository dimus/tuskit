class Milestone < ActiveRecord::Base
  belongs_to :project
  has_many :features

  validates_presence_of :name

  def current?
    self == self.project.current_milestone
  end

  def stories
    strs= []
    self.features.each do |feature|
      strs << feature.stories
    end
    strs.flatten.uniq.sort_by(&:id)
  end

  def features_prepared(aref_date = Date.today)
    to_be_completed = [] 
    completed = []
    incompleted = []
    self.features.each do |f|
      completed_all_stories = f.all_stories_completed?
      if f.completion_date && f.completion_date <= ref_date
        completed << f
      elsif completed_all_stories
        to_be_completed << f
      else
        incompleted << f
      end
    end
    to_be_completed + incompleted + completed.sort_by(&:completion_date)
  end
end
