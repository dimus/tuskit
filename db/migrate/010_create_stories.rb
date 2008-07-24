require 'migration_helpers'
class CreateStories < ActiveRecord::Migration
  extend MigrationHelpers  

  def self.up
    create_table :stories do |t|
      t.integer :iteration_id, :null => false
      t.string :name
      t.float :work_units_est, :default => 0.0
      t.string :created_by
      t.string :updated_by
      t.timestamps 
    end
    
    foreign_key :stories, :iteration_id, :iterations, true
  end

  def self.down
    drop_table :stories
  end
end
