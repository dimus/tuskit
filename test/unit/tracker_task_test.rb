require File.dirname(__FILE__) + '/../test_helper'

class TrackerTaskTest < Test::Unit::TestCase

  def test_belongs_to_tracker
    pt = tasks(:tracker_task1)
    assert_equal pt.class.to_s, 'TrackerTask'
    assert_not_nil pt.tracker
    assert pt.tracker.class.to_s == 'Tracker'
  end

  def test_create
    assert_difference('TrackerTask.count', 1) do
      create
    end
  end

  def test_create_needs_tracker_id
    t = nil
    assert_no_difference('TrackerTask.count') do
      t = create(:tracker_id => nil)
    end
    assert t.errors.on(:tracker_id)
  end


  protected

  def create(options = {})
    TrackerTask.create({
      :tracker_id => 2,
      :name => "New Task",
      }.merge(options))
  end

end
