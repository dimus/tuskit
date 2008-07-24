require File.dirname(__FILE__) + '/../test_helper'

class MeetingTest < Test::Unit::TestCase
  fixtures :meetings

  def test_belongs_to_iteration
    m = Meeting.find 1
    assert_not_nil m.iteration
    assert_equal m.iteration.class.to_s, 'Iteration'
  end
  
  def test_has_participants
    m = Meeting.find 1
    assert_not_nil m.meeting_participants
    assert m.meeting_participants.length > 0
    assert m.meeting_participants[0].class.to_s == 'MeetingParticipant'
  end

end
