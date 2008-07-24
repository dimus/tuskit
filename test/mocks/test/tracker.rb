require 'models/tracker'

class Tracker < ActiveRecord::Base
  def self.get_open_tasks
    return {1  => [
              {
                :tracker_id => 1,
                :tracker_ticket_id => 12,
                :tracker_ticket_submitter => "test@example.com",
                :name => "Update for existing Ticket",
                :notes => "This ticket is already in the system, it has to be updated by this entry",
                :bug => false
              },
              {
                :tracker_id => 1,
                :tracker_ticket_id => 74,
                :tracker_ticket_submitter => "test@example.com",
                :name => "Create Flex user interface for tasks",
                :notes => "Kinda important, not just for kicks",
                :bug => false
                },
              {
                :tracker_id => 1,
                :tracker_ticket_id => 98,
                :tracker_ticket_submitter => "guest",
                :name => "Cannot get into the system!!",
                :notes => "Are you going to fix it or not?",
                :bug => "true"
              }],
            2 => []
           }
  end
end

