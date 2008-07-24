require 'migration_helpers'
class CreateMeetingParticipants < ActiveRecord::Migration
  extend MigrationHelpers  

  def self.up
    create_table :meeting_participants do |t|
      t.integer :meeting_id, :null => false
      t.integer :user_id, :null => false
      t.string :created_by
      t.string :updated_by
      t.timestamps 
    end

    foreign_key :meeting_participants, :meeting_id, :meetings, true
    foreign_key :meeting_participants, :user_id, :users, true
    add_index :meeting_participants, [:meeting_id,:user_id], :unique => true

  end

  def self.down
    drop_table :meeting_participants
  end
end
