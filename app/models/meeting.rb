class Meeting < ActiveRecord::Base
  belongs_to :iteration
  has_many :meeting_participants

  validates_presence_of :name
  validates_presence_of :meeting_date
end
