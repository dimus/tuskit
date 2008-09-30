require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feature do
  before(:each) do
    @milestone = mock_model(Milestone)
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :milestone => @milestone,
      :completion_date => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    Feature.create!(@valid_attributes)
  end

  it "should have name" do
    @valid_attributes.merge!({:name => nil})
    feature = Feature.new(@valid_attributes)
    feature.should_not be_valid
    feature.save.should be_false
    feature.errors.should_not be_empty
  end
end
