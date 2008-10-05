class Milestone < ActiveRecord::Base
  belongs_to :project
  has_many :features

  validates_presence_of :name

  def current?
    self == Milestone.find(:first, :conditions => "completion_date is null")
  end
end
