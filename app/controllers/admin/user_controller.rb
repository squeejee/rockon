class Admin::UserController < ApplicationController  
  include AuthenticatedSystem
  layout "admin"
  before_filter :login_required
  
  active_scaffold :user do |config|
    config.label = "Users"
    config.columns = [:team_name, :login, :first_name, :last_name, :email, :commish, :password, :password_confirmation]
    list.columns.exclude :password, :password_confirmation
    list.sorting = {:first_name => 'ASC'}
  end
end
