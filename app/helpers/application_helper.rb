# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_type
    "developer"
  end
    
  def page_title
    return page_type.camelize + " View"
  end
  
  def tabs
    tabs  = "  " * 8 + "<ul id=\"tabs\">\n" + "  " * 8
    tabs += tab "Home", current_iterations_url
    get_projects_for_tabs.each do |p|
        url = p.current_iteration ? project_iteration_url(p, p.current_iteration) : project_iterations_url(p)
      tabs += tab(p.name, url)
    end  
    tabs += "\n" + "  " * 8 + "</ul>\n"
  end
  
  def tab(label, tab_url)
    if current_tab == label #controller.controller_name =~ /#{options[:controller].split('/').last}/
      content_tag :li, link_to(label, tab_url, {"class"=> "active"}), {"class"=> "active"}
    else
      content_tag :li, link_to(label, tab_url)
    end
  end
  
  def current_tab
    project_id = get_current_project_id
    if project_id
      projects = get_projects_for_tabs
      projects.each do |p|
        return p.name if p.id == project_id
      end
    end
    return "Home"
  end
  
  #returns project tabs that should be shown on the page
  def get_projects_for_tabs
    projects = current_user.projects.find(:all).find_all {|p| p.current_iteration}
    projects = projects.sort {|x,y| y.current_iteration.daily_load <=> x.current_iteration.daily_load}
    current_project = Project.find(get_current_project_id) if get_current_project_id
    projects << current_project if (current_project && !projects.include?(current_project))
    projects
  end
  
  def project_subtabs(project_id, current_subtab = nil)
    subtabs_hash = []
    if project_id
      subtabs = [ 
          ["Project", edit_project_url(project_id)], 
          ["Members", project_project_members_url(project_id)],
          ["Iterations", project_iterations_url(project_id)]
        ]
      subtabs.each do |stb|
        subtabs_hash << {
            :name => stb[0], 
            :url => stb[1], 
            :active => (stb[0] == current_subtab)
          }
      end
    end
    generate_subtabs subtabs_hash unless subtabs_hash.empty?  
  end
  
  # Generates html code for subtabs. It takes elements of array of hashes:
  # Usage:
  # generate_subtabs elements
  def generate_subtabs(elements)
    subtabs = %{<div id = "subtabs-container">}
    subtabs += %{<ul id = "subtabs">}
    elements.each do |element|
      class_active = nil
      options = {}
      if element[:active]
        class_active = ' class="active"'
        options = {:class => "active"}
      end 
      subtabs +=  "<li#{class_active}>" + link_to(element[:name], element[:url], options) + "</li>"
    end
    subtabs += "</ul>\n</div>\n"
    subtabs
  end
  
  #Returns id of a currently selected project. Returns nil if nothing is selected
  def get_current_project_id
     @project.id rescue nil
  end
  
  def render_flash
    output = []

    for value in flash[:error]
      output << "<span class=\"error\">#{value}</span>"
    end if flash && flash[:error]
    
    for value in flash[:notice]
      output << "<span class=\"notice\">#{value}</span>"
    end if flash && flash[:notice]
    
    flash[:error] = []
    flash[:notice] = []

    output.join("<br/>\n")
  end
  
  def format_date(date,format='%m/%d/%y')
    date.strftime(format)
  end
  
  def dates_interval(date1, date2)
    raise ArgumentError, "#{format_date(date1)} is bigger than #{format_date(date2)}" if date1 > date2
    date_string = format_date(date1) + " - "
    if date1.year == date2.year
      date_string += format_date(date2, '%m/%d')
    else
      date_string += format_date(date2)
    end
    date_string  
  end

  def checked?(expr)
    if expr
      return 'checked="checked"'
    else
      return ''
    end
  end

  def selected?(expr)
    if expr
      return 'selected="selected"'
    else
      return ''
    end
  end

  def url_admin
    {:controller => "/users"}
  end

  def url_developer
    {:controller => "/current_iterations"}
  end
  
  def url_customer
    {:controller  => "/sessions"}
  end

  def drawer(drawer_id, title, drawer_opened_data, drawer_closed_data=nil, open=false)
  
    drawerState="drawer_closed"
    contentDisplay="none"
    textDisplay="block"
    if open
      drawerState="drawer_open"
      contentDisplay="block"
      textDisplay="none"
    end

    drawer="
    <div id=\"#{drawer_id}_drawer\" class=\"#{drawerState}\">
    <a href=\"#\" onclick=\"toggleDrawer('#{drawer_id}')\" >#{title}</a>\n"
    if drawer_closed_data
      drawer += "
          <div id=\"#{drawer_id}_drawer_text\" style=\"padding:1em;display:#{textDisplay}\">
#{drawer_closed_data}
          </div>\n"
    end
    drawer +="</div> 
    <div id=\"#{drawer_id}_drawer_content\" class=\"drawer_content\" style=\"display:#{contentDisplay}\">
#{drawer_opened_data}
    <span class=\"clear_floats\"></span>
    </div>"
    
  end

end