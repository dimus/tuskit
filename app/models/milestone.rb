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

  def features_prepared
    completed = []
    incompleted = []
    self.features.each do |f|
      if f.completion_date
        completed << f
      else 
        incompleted << f
      end
    end
    incompleted + completed.sort_by(&:completion_date)
  end
end
