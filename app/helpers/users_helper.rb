module UsersHelper
  
  def page_type
    @page_title || "admin" rescue "admin"
  end
end