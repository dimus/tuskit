require File.dirname(__FILE__) + '/../test_helper'

class MeetingParticipantTest < Test::Unit::TestCase

  def test_belongs_to_meeting
    p = MeetingParticipant.find 1
    assert_not_nil p.meeting
    assert p.meeting.class.to_s == 'Meeting'
  end
  
  def test_create
    assert_difference('MeetingParticipant.count', 1) do
      create
    end
  end
  
  def test_do_not_create_duplicates
    mp = nil
    assert_no_difference('MeetingParticipant.count') do
      mp = create(:user_id => 1)
    end
    assert_not_nil mp.errors.on('user_id') 
  end

  def test_create_needs_user_id
    mp = nil
    assert_no_difference('MeetingParticipant.count') do
      mp = create(:user_id => nil)
    end
    assert_not_nil mp.errors.on('user_id') 
  end

  def test_create_needs_meeting_id
    mp = nil
    assert_no_difference('MeetingParticipant.count') do
      mp = create(:meeting_id => nil)
    end
    assert_not_nil mp.errors.on('meeting_id') 
  end


  protected

  def create(options = {})
    MeetingParticipant.create({
      :meeting_id => 1,
      :user_id => 3, 
      }.merge(options))
  end

end
