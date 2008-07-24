require 'remote_tracker'
class Tracker < ActiveRecord::Base
  extend RemoteTracker
  has_many :projects
  has_many :tracker_tasks
  
  validates_presence_of :application, :uri
  
  def self.get_open_tasks()
    retval = {}
    trackers = Tracker.find(:all)
    trackers.each do |t|
      connector = remote_tracker_factory(t)
      #puts connector
      tasks = connector.get_open_tasks
      retval[t.id] = tasks
    end
    retval
  end
end
