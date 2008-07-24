require 'migration_helpers'
class CreateMemberships < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :memberships do |t|
      t.integer  :user_id     
      t.integer  :group_id    
      t.string   :created_by   
      t.string   :updated_by  
      t.timestamps  
    end
    
    foreign_key :memberships, :user_id, :users, true
    foreign_key :memberships, :group_id, :groups, true
    add_index   :memberships, [:user_id,:group_id], :unique => true
  end

  def self.down
    drop_table :memberships
  end
end
