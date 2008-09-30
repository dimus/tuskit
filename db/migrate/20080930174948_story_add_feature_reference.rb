class StoryAddFeatureReference < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.references :feature
    end
  end

  def self.down
    remove_column :stories, :feature_id
  end
end
