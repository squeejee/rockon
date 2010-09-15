# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_rockon_session_id'
  
  before_filter :set_user_time_zone
  before_filter :mailer_set_url_options
  
  include AuthenticatedSystem  
    
  def current_user
    session[:user]
  end
  
  private
  
  def set_user_time_zone
    Time.zone = User.find(current_user).time_zone if logged_in?
  end
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
end
