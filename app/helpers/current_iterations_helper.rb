module CurrentIterationsHelper
  def link_to_stories(link_text, iteration, options={})
    link_to h(link_text), iteration_stories_url(iteration), options
  end
end
