class Admin < Padrino::Application  
  
  ## 
  # Padrino Core
  #
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  set :login_page, "/admin/sessions/new"
  disable :store_location
  
  ##
  # Access Control Rules.
  #
  
  # Any
  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end
  
  # Admin
  access_control.roles_for :admin do |role|
    role.project_module :posts, "/posts"
    role.project_module :tasks, "/tasks"
    role.project_module :defaults, "/defaults"
    role.project_module :notes, "/notes"
    role.project_module :lists, "/lists"
    role.project_module :things, "/things"
    role.project_module :codes, "/codes"
    role.project_module :quotes, "/quotes"
    role.project_module :commentaries, "/commentaries"
    role.project_module :audios, "/audios"
    role.project_module :videos, "/videos"
    role.project_module :galleries, "/galleries"
    role.project_module :replies, "/replies"
    role.project_module :comments, "/comments"
    role.project_module :accounts, "/accounts"          
  end      
  
end