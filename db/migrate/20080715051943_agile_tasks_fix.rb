class AgileTasksFix < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :work_units_est, :task_units
    remove_column :tasks, :work_units_real
  end

  def self.down
    add_column :tasks, :work_units_real
    rename_column :tasks, :task_units, :work_units_est
  end
end
