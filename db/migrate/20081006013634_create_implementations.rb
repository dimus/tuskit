class CreateImplementations < ActiveRecord::Migration
  def self.up
    remove_column :stories, :feature_id
    
    create_table :implementations do |t|
      t.references :feature
      t.references :story
      t.timestamps
    end
  end

  def self.down
    drop_table :implementations
    change_table :stories do |t|
      t.references :feature
    end
  end
end
