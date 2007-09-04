# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  # The following controllers require SSL
  # ssl_required :new, :create
  # The following controllers will allow SSL if the user accesses page via HTTPS
  # ssl_allowed 

  # render new.rhtml
  def new
    unless params[:return_to].nil?
      session[:return_to] = params[:return_to]
    end
    @page_title = "Please sign in"
  end

  def create
    @page_title = "Please sign in"
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        User.find(current_user).remember_me
        cookies[:auth_token] = { :value => User.find(current_user).remember_token , :expires => User.find(current_user).remember_token_expires_at }
      end
      redirect_back_or_default('/auctions')
      flash[:notice] = "Logged in successfully"
    else
      flash[:error] = "Incorrect login or password."
      render :action => 'new'
    end
  end
  
  def terms
    @page_title = "Terms of service"
  end
  
  def privacy
    @page_title = "Privacy policy"
  end

  def destroy
    User.find(current_user).forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    if params[:return_to].nil?
      redirect_back_or_default('/login')
    else  
      render :action => 'new'
    end
  end
end