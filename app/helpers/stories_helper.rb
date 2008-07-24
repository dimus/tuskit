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
    can_be_completed = story.agile_tasks.empty? ? false : true
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
      link_text = "Done Story"
    elsif story_can_be_completed?(story):
      link_text = '<span style = "color:red">Done Story?</span>'
    else
      return "Not Done Story"
    end
    link_to link_text, iteration_story_url(story.iteration_id, story.id, :story => {:completed => story.completed ? 0 : 1}), :method => :put, :confirm => story.completed ? "Mark '#{story.name}' as not completed?" : "Mark story '#{story.name}' as completed?"
  end

end