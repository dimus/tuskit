class MeetingParticipant < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :user
  
  validates_uniqueness_of :user_id , :scope => :meeting_id, :message => 'The user already participate at the meeting'
  validates_presence_of :user_id, :meeting_id
  
end
