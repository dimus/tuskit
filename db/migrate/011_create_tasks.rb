require 'migration_helpers'
class CreateTasks < ActiveRecord::Migration
  extend MigrationHelpers  

  def self.up
    create_table :tasks do |t|
      t.string :type
      
      #Task common_attributes
      t.integer :tracker_ticket_id
      t.string :tracker_ticket_submitter
      t.string :name
      t.text :notes
      t.date :completion_date
      t.boolean :bug      
      t.string :created_by
      t.string :updated_by
      t.timestamps 
      
      #TrackerTask
      t.integer :tracker_id
      
      #ProjectTask
      t.integer :project_id
      
      #AgileTask
      t.integer :story_id
      t.float :work_units_est
      t.float :work_units_real
      
    end
    
    foreign_key :tasks, :project_id, :projects, true
    foreign_key :tasks, :story_id, :stories, true
    foreign_key :tasks, :tracker_id, :trackers, true
    add_index :tasks, :tracker_ticket_id, :unique => true
  end

  def self.down
    drop_table :tasks
  end
end
