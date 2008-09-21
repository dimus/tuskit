class StoryAddCompletionDate < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.date :completion_date
      t.text :description
    end
    Story.find(:all,:conditions => "completed = 1").each do |story|
      story.completion_date =  Task.find(:first,:conditions => ["completion_date is not null and story_id = ?", story.id], :order => 'completion_date desc').completion_date
      story.save
    end
    remove_column :stories, :completed 
  end

  def self.down
    add_column :stories, :completed, :integer
    Story.all.each do |story|
      completed = 0
      if story.completion_date
        completed = 1
      end
      execute "update stories set completed = #{completed} where id = #{story.id}"
    end
    change_table :stories do |t|
      t.remove :completion_date
      t.remove :description
    end
  end
end
