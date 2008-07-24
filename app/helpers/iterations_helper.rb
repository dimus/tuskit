module IterationsHelper
  def link_to_iteration(link_text, iteration, options={})
    link_to h(link_text), iteration_stories_url(iteration), options
  end
end
