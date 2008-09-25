namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'rubygems'
    require 'populator'
    [Project, Iteration, Story, Task].each(&:delete_all)
    Project.populate 5..10 do |project|
      project.name = Populator.words(1..2).titleize
      project.start_date = 2.years.ago..Time.now
      project.iteration_length = [14,14,14,21,28,30]
      project.progress_reports = rand < 0.8 ? 1 : 0
      project.created_by = project.updated_by =  User.all.select {|u| u.groups.include?(Group.find_by_name("developer"))}.shuffle[0].login 
    end
    Project.all.each do |project|
      users = User.all.shuffle
      ProjectMember.populate 3..6 do |member|
        member.project_id = project.id
        member.user_id = users.pop
        member.active = rand < 0.8 ? 1 : 0
        member.send_iteration_report = rand < 0.9 ? 1 : 0
      end
      start_date = project.start_date
      while start_date < Date.today
        iteration = Iteration.new
        iteration.project_id = project.id
        iteration.start_date = start_date
        iteration.end_date = rand < 0.8 ? (start_date + project.iteration_length.days) : (start_date + project.iteration_length.days) + ((rand * 8).to_i - 4)
        iteration.objectives = Populator.sentences(1..2)
        start_date = iteration.end_date
        start_date += rand < 0.8 ? 0 : (rand * 10).to_i
        iteration.save
      end 
    end
  end
  
end
