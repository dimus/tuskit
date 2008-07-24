require 'migration_helpers'
class CreateGroups < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :groups do |t|
      t.string    :name
      t.string    :description
      t.string    :created_by
      t.string    :updated_by
      t.timestamps
    end
    
    group_names = ['admin','developer','customer']
    group_names.each do |name|
      Group.create :name => name, :created_by => 'system', :updated_by => 'system'
    end    
    
    create_fixture(:groups)
    add_index :groups, :name
  end
  
  def self.down
    drop_table :groups
  end
end
