ActionController::Routing::Routes.draw do |map|
  map.resources :milestones, :has_many => [:features]

  map.resources :features

  map.resources :task_owners

  map.resources :tracker_tasks
  
  map.resources :project_tasks
  
  map.resources :agile_tasks

  map.resources :stories

  map.resources :meeting_participants

  map.resources :project_members
  
  map.resources :current_iterations
  
  map.resources :users, :has_many => [:groups, :memberships]
  map.resources :sessions, :trackers, :groups, :memberships
  
  map.resources :projects, :has_many => [:milestones, :iterations, :reports, :users, :project_members]
  map.resources :iterations, :has_many => [:meetings, :stories]
  map.resources :stories, :has_many => [:agile_tasks]
  map.resources :meetings, :has_many => [:meeting_participants]

  
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.with_options :controller => 'sessions' do |sessions|
    sessions.root
    sessions.login  '/login', :action => 'new'
    sessions.logout '/logout', :action => 'destroy'    
  end
  
  
  map.admin_exists '/admin_exists', :controller => 'memberships', :action => 'admin_exists'
  #map.connect ':controller/:action/:id.:format'
  #map.connect ':controller/:action/:id'
end
