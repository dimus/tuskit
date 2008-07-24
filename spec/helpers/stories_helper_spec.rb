require File.dirname(__FILE__) + '/../spec_helper'


describe StoriesHelper do
  describe ".participants" do
    before do
      @part1 = mock_model(MeetingParticipant, :user => mock_model(User, :full_name => 'dd dd'))
      @part2 = mock_model(MeetingParticipant, :user => mock_model(User, :full_name => 'aa aa'))
      @meeting = mock_model(Meeting, :meeting_participants => [@part1, @part2])
    end

    it "should return list of meeting participants" do
      helper.participants(@meeting).should == "dd dd, aa aa"
    end

    it "should return empty string when there are no participants" do
      @meeting = mock_model(Meeting, :meeting_participants => [])
      helper.participants(@meeting).should == ""
    end
  end

  describe ".story_completion" do
  end
end
