require 'migration_helpers'
class CreateProjects < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :projects do |t|
      t.integer   :parent_id, :null => true
      t.integer   :tracker_id
      t.string    :name
      t.string    :description
      t.string    :tracker_project
      t.datetime  :start_date
      t.datetime  :end_date
      t.integer   :iteration_length, :default => 14
      t.boolean   :progress_reports, :default => true
      t.string    :created_by
      t.string    :updated_by
      t.timestamps
    end
    
    foreign_key :projects, :tracker_id, :trackers, true
    foreign_key :projects, :parent_id, :projects, true #on delete cascade is on (to keep tests renewable)
    add_index :projects, :name, :unique => true
  end
  
  

  def self.down
    drop_table :projects
  end
end
