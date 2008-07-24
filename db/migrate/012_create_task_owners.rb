require 'migration_helpers'
class CreateTaskOwners < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :task_owners do |t|
      t.integer :user_id
      t.integer :agile_task_id
      t.string :created_by
      t.string :updated_by
      t.timestamps 
    end
    
    foreign_key :task_owners, :user_id, :users, true
    foreign_key :task_owners, :agile_task_id, :tasks, true
    add_index   :task_owners, [:agile_task_id,:user_id], :unique => true
  end

  def self.down
    drop_table :task_owners
  end
end
