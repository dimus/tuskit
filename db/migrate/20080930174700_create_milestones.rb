class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.references :project
      t.string :name
      t.text :description
      t.date :deadline
      t.date :completion_date

      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end
