require File.dirname(__FILE__) + '/../spec_helper'

describe Iteration, 'with fixtures loaded' do
  fixtures :trackers, :projects, :iterations, :meetings, :stories, :tasks
  
  it 'should have several iterations' do
    Iteration.all.should_not be_empty
    Iteration.should have_at_least(2).records
  end
  
  it 'should belong to project' do
    iterations(:admin_view).project.should == projects(:tuskit)
    iterations(:admin_view).project.should be_instance_of(Project)
  end
  
  it 'should be able to have stories' do
    iterations(:admin_view).stories.should have_at_least(2).records
    iterations(:admin_view).stories.first.should be_instance_of(Story)
  end
  
  it 'should be able to have agile tasks' do
    iterations(:admin_view).agile_tasks.should have_at_least(2).records
    iterations(:admin_view).agile_tasks.first.should be_instance_of(AgileTask)
  end
  
  it 'should be able to have meetings' do
    iterations(:admin_view).meetings.should have_at_least(2).records
    iterations(:admin_view).meetings.first.should be_instance_of(Meeting)
  end
  
  describe ".agile_tasks_number" do
    it "should return number of agile tasks" do
      iterations(:admin_view).agile_tasks_number.should == 2
    end
  end
  
  describe ".work_units_real" do
    it "should return sum of work units from completed agile tasks" do
      iterations(:admin_view).work_units_real.should == 8.0
    end
  end
  
  describe ".complete_tasks" do
    it "should return instances of completed agile tasks" do
      iterations(:admin_view).complete_tasks.should have(2).records
      iterations(:admin_view).complete_tasks.first.should be_instance_of(AgileTask)
    end
  end
end

describe Iteration, "without iterations fixture" do
  fixtures :projects
  before(:each) do
    project = projects(:tuskit)
    @iteration = Iteration.new(:project => project, :start_date => 15.days.from_now.to_s, :end_date => 3.days.from_now.to_s, :work_units => 20)
    @iteration.stub!(:work_units_real).and_return(10)
  end

  describe '.burndown' do
  end
  
  it "should know daily load for remaining days" do
    @iteration.daily_load.should == 2.5
  end
  
  it "should be valid" do
    @iteration.should be_valid
    @iteration.save.should be_true
    @iteration.errors.should be_empty
  end
  
  it "should have start_date" do
    @iteration.start_date = nil
    @iteration.should_not be_valid
    @iteration.save.should be_false
    @iteration.errors.should_not be_empty
  end
  
  it "should have end_date" do
    @iteration.end_date = nil
    @iteration.should_not be_valid
    @iteration.save.should be_false
    @iteration.errors.should_not be_empty
  end
end
