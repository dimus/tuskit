#requires gems facets and populator. 
namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'rubygems'
    require 'facets'
    require 'populator'
    [Project, Iteration, Story, Task].each(&:delete_all)
    Project.populate 5..10 do |project|
      project.name = Populator.words(1..2).titleize
      project.start_date = 2.years.ago..Time.now
      project.iteration_length = [14,14,14,21,28,30]
      project.progress_reports = rand < 0.8 ? 1 : 0
      project.created_by = project.updated_by =  User.all.select {|u| u.groups.include?(Group.find_by_name("developer"))}.shuffle[0].login 
    end
#populate project members
    Project.all.each do |project|
      precision_weight = 60
      users = User.all.shuffle
      ProjectMember.populate 3..6 do |member|
        member.project_id = project.id
        member.user_id = users.pop
        member.active = rand < 0.8 ? 1 : 0
        member.send_iteration_report = rand < 0.9 ? 1 : 0
      end
#create iterations
      start_date = project.start_date
      prev_iteration = nil
      while start_date < Date.today
        iteration = Iteration.new
        iteration.project_id = project.id
        iteration.start_date = start_date
        iteration.end_date = rand < 0.8 ? (start_date + project.iteration_length.days) : (start_date + project.iteration_length.days) + ((rand * 8).to_i - 4)
        iteration.objectives = Populator.sentences(1..2)
        iteration.work_units =  prev_iteration ? prev_iteration.work_units_real : (((iteration.end_date - iteration.start_date)/86400) * 3).to_i
        iteration.save
        
        prev_iteration = iteration
        start_date = iteration.end_date
        start_date += rand < 0.8 ? 0 : (rand * 10).to_i
        precision_weight = precision_weight/2 + rand * precision_weight
        precision = rand * precision_weight - precision_weight/2

#create stories for iteration
        while iteration.work_units_planned < 40 # (iteration.work_units + precision)
          story = Story.new 
          story.iteration_id = iteration.id
          story.name = Populator.words 4..12
          story.description = Populator.paragraphs 0..3
          story.work_units_est = [1,1,1,1,1,2,2,2,2,4,4,4,4,8,8,8,8,8,12,12,12,16,16].shuffle[0]
          if iteration.current?
            story.completion_date = rand < 0.5 ? (iteration.start_date.to_date .. Date.today).to_a.shuffle[0] : nil
          else
            story.completion_date = rand < 0.9 ? (iteration.start_date.to_date .. iteration.end_date.to_date).to_a.shuffle[0] : nil
          end
          story.save
          iteration.reload
#create tasks for story
          story_tasks_value = 0 
          while story_tasks_value   < 8 #story.work_units_est 
            tsk = AgileTask.new
            tsk.story_id = story.id
            tsk.task_units = [1,1,1,1.5,2,2,2,2,2,2,2,2,2,2.5,3,3.5,4,4,4,4.5,5].shuffle[0]
            tsk.name = Populator.words(2..12)
            tsk.notes = Populator.sentences(0..5)
            tsk.bug = rand < 0.9 ? 0 : 1
            if iteration.current?
              tsk.completion_date = rand < 0.5 ? (iteration.start_date.to_date..Date.today).to_a.shuffle[0] : nil
            else
              completion_end_interval = story.completion_date ? story.completion_date : iteration.end_date
              tsk.completion_date = (iteration.start_date.to_date..completion_end_interval.to_date).to_a.shuffle[0]
            end
            tsk.save
            story.reload
            story_tasks_value = (story.agile_tasks.inject(0) {|res, task| res += task.task_units } )
            potential_owners = project.developers.shuffle
            task_owners = potential_owners[0..[1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3].shuffle[0]]
            
            task_owners.each do |member|
              TaskOwner.create :user_id => member.user.id, :agile_task_id => tsk.id
            end
          end
        end
      end
    end
  end
end
