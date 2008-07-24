require 'xmlrpc/client'
module RemoteTracker
  def remote_tracker_factory(tracker)
    eval(tracker.application + 'Tracker.new(tracker)')
  end
  
  class Tracker
    def get_open_tasks
      {}
    end
  end

  class TracTracker < Tracker
    def initialize(tracker)
      @connector = XMLRPC::Client.new2(
        "https://guest:guest@trac.informatics.sunysb.edu/projects/xptrac/login/xmlrpc", nil, 30
      )
    end
    
    def get_open_tasks
      task_list = []
      task_ids = @connector.call("ticket.query")
      task_ids.each do |i|
        task = @connector.call("ticket.get", i)
        task_hash = prepare_task_hash task
        task_list << task_hash
      end
      task_list
    end
    
  end
    
end
