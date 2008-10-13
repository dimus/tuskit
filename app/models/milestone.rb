class Milestone < ActiveRecord::Base
  belongs_to :project
  has_many :features

  validates_presence_of :name

  def current?
    self == self.project.current_milestone
  end
end
