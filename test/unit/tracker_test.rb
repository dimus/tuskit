require File.dirname(__FILE__) + '/../test_helper'

class TrackerTest < Test::Unit::TestCase

  def test_should_create
    new_tracker = nil
    assert_difference('Tracker.count', 1) do
      new_tracker = create_tracker
    end
    assert_equal new_tracker.name, "GTDelux"
  end
  
  def test_should_have_application_to_create
    count_before = Tracker.count()
    t = create_tracker({:application => nil})
    assert_equal count_before, Tracker.count()
    assert t.errors.on(:application)
  end
 
  def test_should_have_uri_to_create
    count_before = Tracker.count()
    t =create_tracker({:uri => nil})
    assert_equal count_before, Tracker.count()
    assert t.errors.on(:uri)
  end
  
  def test_should_update_any_field
    tracker = trackers(:tuskit)
    tracker.update_attributes({:name => 'newTracker'})
    assert_equal tracker.name, "newTracker" 
    
    tracker.name = 'new_one'
    tracker.save!
    assert_equal tracker.name, "new_one"
  end
  
  def test_should_delete_lonely
    first_count = Tracker.count
    t = create_tracker
    second_count = Tracker.count
    t.destroy
    assert_equal first_count, Tracker.count
    assert_equal first_count + 1, second_count
  end
  
  #foreign keys should prevent deleting tracker from the syste
  #in case if there is already somethin assigned to them.
  def test_should_not_delete_if_connected_to_project
    tracker = trackers(:tuskit)
    assert_raises(ActiveRecord::StatementInvalid) { tracker.destroy } 
  end
  
  def test_has_tracker_tasks
    t = trackers(:tuskit)
    assert_not_nil t.tracker_tasks
    assert t.tracker_tasks.length > 0
    assert_equal t.tracker_tasks[0].class.to_s, 'TrackerTask'
  end
  
  def test_tracker_remote_update
    result = Tracker.get_open_tasks()
    assert result.is_a?(Hash)
    #puts result.to_yaml
  end
  
  private
    def create_tracker(options = {})
      Tracker.create({
        :application => "Trac",
        :name => "GTDelux",
        :uri => "http://remote_user:secret@gtdelux.com/trac"
        }.merge(options))
    end
end
