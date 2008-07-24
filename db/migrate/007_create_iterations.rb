require 'migration_helpers'
class CreateIterations < ActiveRecord::Migration
  extend MigrationHelpers  
  
  def self.up
    create_table :iterations do |t|
      t.integer :project_id, :null => false
      t.text :objectives
      t.date :start_date, :default => Time.now.to_date.to_formatted_s 
      t.date :end_date
      t.float :work_units, :default => 0.0
      t.boolean :report_sent, :default => false
      t.string :created_by
      t.string :updated_by

      t.timestamps 
    end
    
    foreign_key :iterations, :project_id, :projects, true #on delete cascade
    add_index :iterations, :start_date
  end

  def self.down
    drop_table :iterations
  end
end
