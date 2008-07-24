require 'migration_helpers'
class CreateMeetings < ActiveRecord::Migration
  extend MigrationHelpers  
  
  def self.up
    create_table :meetings do |t|
      t.integer :iteration_id, :null => false
      t.date :meeting_date
      t.float :length, :default => 1
      t.string :name, :default => 'Iteration Meeting'
      t.text :notes
      t.string :created_by
      t.string :updated_by
      t.timestamps 
    end
    
    foreign_key :meetings, :iteration_id, :iterations, true #on delete cascade
    add_index :meetings, :meeting_date
    add_index :meetings, :iteration_id
  end

  def self.down
    drop_table :meetings
  end
end
