module AgileTasksHelper

  def developers_list(story,task) 
    developers_list = ''
    story.project.developers.each do |d|
      developers_list += "<input type=\"checkbox\" name=\"user_ids[]\" id=\"user_ids_#{d.user.id}\" value=\"#{d.user.id}\" " + checked?(task.task_owners.map {|o| o.user_id}.include?(d.user_id)) + " />
    	<label for=\"user_ids_#{d.user.id}\">#{d.user.full_name}
    	</label><br />"
    end
    developers_list
  end

  def task_developers(task)
    task_developers = ''
    task.task_owners.each do |owner|
      task_developers += User.find(owner.user_id).full_name + "<br />"
    end
    if task_developers == ''
      task_developers = "This task is unowned"
    end
    task_developers  
  end

end
