require 'migration_helpers'
class CreateTrackers < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :trackers do |t|
      t.string  :application
      t.string  :name
      t.string  :uri
      t.string  :created_by
      t.string  :updated_by
      t.timestamps
    end
    
    add_index :trackers, :name, :unique => true
  end

  def self.down
    drop_table :trackers
  end
end
