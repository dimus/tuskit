require File.dirname(__FILE__) + '/../spec_helper'

describe Meeting, 'with fixtures loaded' do
  fixtures :iterations, :meetings, :users, :meeting_participants
  
  it 'should have several meetings' do
    Meeting.all.should_not be_empty
    Meeting.all.should have_at_least(2).records
  end
  
  it 'should belong to iteration' do
    meetings(:iter).iteration.should be_instance_of(Iteration)
  end
  
  it 'should be able to have meeting_participants' do
    meetings(:iter).meeting_participants.should have_at_least(2).records
    meetings(:iter).meeting_participants.first.should be_instance_of(MeetingParticipant)
  end
  
  it 'should destroy self' do
    lambda {meetings(:iter).destroy}.should change(Meeting, 'count').by(-1)
  end

  it 'should destroy self and meeting participants' do
    lambda {meetings(:iter).destroy}.should change(MeetingParticipant, 'count').by(-2)
  end

end

describe Meeting, "without iterations fixture" do
  
  before(:each) do
    @iteration = mock_model(Iteration)
    @meeting = Meeting.new(:iteration => @iteration, :meeting_date => Date.today)
  end

  it "should be valid" do
    @meeting.should be_valid
  end

  it "should have default name" do
    Meeting.new.name.should == "Iteration Meeting"
  end

  it "should have meeting_date" do
    @meeting.meeting_date = nil
    @meeting.should_not be_valid
  end

  it "should have name" do
    @meeting.name = nil
    @meeting.should_not be_valid
  end

end
