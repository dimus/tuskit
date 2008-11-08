module FeaturesHelper

  def feature_can_be_completed?(feature)
    return false if feature.stories.blank?
    feature.stories.each do |story|
      return false unless story.completed
    end
    true
  end

  def feature_completion(feature)
    link_text = ""
    if feature.completion_date
      link_text = '<span class="folder_item_button folder_item_done">Done</span>'
    elsif feature_can_be_completed?(feature)
      link_text = '<span class="folder_item_button folder_item_to_close">Done?</span>'
    else
      link_text = "<span class=\"folder_item_button folder_item_todo\">To do</span>"
    end
    link_to link_text, milestone_feature_url(feature.milestone.id, feature.id, :feature => {:completion_date => feature.completion_date ? nil : Date.today.to_s}), :method => :put, :confirm => feature.completion_date ? "Mark '#{feature.name}' as not completed?" : "Mark story '#{feature.name}' as completed?"
  end
end
