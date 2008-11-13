require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Milestone do
  before(:each) do
    @project = mock_model(Project)
    @valid_attributes = {
      :project => @project,
      :name => "value for name",
      :description => "value for description",
      :deadline => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    Milestone.create!(@valid_attributes)
  end

  it "should have a name" do
    @valid_attributes.merge!({:name => nil})
    milestone = Milestone.new(@valid_attributes)
    milestone.should_not be_valid
    milestone.save.should be_false
    milestone.errors.should_not be_empty
  end
end
