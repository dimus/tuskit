require 'migration_helpers'
class CreateProjectMembers < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :project_members do |t|
      t.integer :user_id, :null => false
      t.integer :project_id, :null => false
      t.boolean :active, :default => true
      t.boolean :send_iteration_report, :default => true
      t.string :created_by
      t.string :updated_by
      t.timestamps 
    end
    
    foreign_key :project_members, :user_id, :users, true
    foreign_key :project_members, :project_id, :projects, true
    add_index:project_members, [:project_id,:user_id], :unique => true
  end

  def self.down
    drop_table :project_members
  end
end
