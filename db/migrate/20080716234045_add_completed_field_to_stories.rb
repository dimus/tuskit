class AddCompletedFieldToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :completed, :boolean

  end

  def self.down
    remove_column :stories, :completed
  end
end
