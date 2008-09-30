class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :name
      t.text :description
      t.references :milestone
      t.date :completion_date

      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
