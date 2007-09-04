class AdminController < ApplicationController 
  include AuthenticatedSystem
  layout "admin"
  before_filter :login_required
  
  def show
    
  end
end
