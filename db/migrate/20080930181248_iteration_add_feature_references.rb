class IterationAddFeatureReferences < ActiveRecord::Migration
  def self.up
    change_table :iterations do |t|
      t.references :milestone
      t.references :feature
    end
  end

  def self.down
    remove_column :iterations, :feature_id
    remove_column :iterations, :milestone
  end
end
