module StoriesHelper

  def participants(meeting)
    participants = []
    meeting.meeting_participants.each do |p|
      participants << p.user.full_name
    end
    participants.join(", ")
  end

  def task_owners(task)
    owners = []
    task.task_owners.each do |owner|
      owners << User.find(owner.user_id).login
    end
    owners = owners.join(", ")
    owners == "" ? "-" : owners
  end

  def link_to_task(link_text, task)
    link_to link_text, :controller => "agile_tasks", :action => "edit", :story_id => task.story_id, :id => task.id
  end

  def story_can_be_completed?(story)
    can_be_completed = (story.agile_tasks.empty? || !story.iteration.current?) ? false : true
    story.agile_tasks.each do |task|
      if !task.completion_date
        can_be_completed = false
        break
      end
    end
    can_be_completed
  end

  def story_completion(story)
    link_text = ""
    if story.completed
      link_text = '<span class="folder_item_button folder_item_done">Done</span>'
    elsif story_can_be_completed?(story):
      link_text = '<span class="folder_item_button folder_item_to_close">Done?</span>'
    else
      msg = story.iteration.current? ? 'To do' : 'Unfinished' 
      link_text = "<span class=\"folder_item_button folder_item_unfinished\">#{msg}</span>"
      return link_text if !story.iteration.current?
    end
    link_to link_text, iteration_story_url(story.iteration_id, story.id, :story => {:completion_date => story.completed ? nil : Date.today.to_s}), :method => :put, :confirm => story.completed ? "Mark '#{story.name}' as not completed?" : "Mark story '#{story.name}' as completed?"
  end

end
