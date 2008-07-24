class IterationAddImportOldStories < ActiveRecord::Migration
  def self.up
    add_column :iterations, :old_stories_added, :boolean, :default => 0
  end

  def self.down
    remove_column :iterations, :old_stories_added
  end
end
