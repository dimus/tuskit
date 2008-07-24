class ProjectMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_uniqueness_of :user_id , :scope => :project_id, :message => 'The user is already a member of the progect'
  validates_presence_of :user_id, :project_id
end
