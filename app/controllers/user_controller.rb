class UserController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :login_required, :except => [:new, :create, :forgot_password, :activate]
   
  # The following controllers require SSL
  # ssl_required :new, :create, :edit, :update
  # The following controllers will allow SSL if the user accesses page via HTTPS
  #ssl_allowed 
  
  
  # GET /users/1
  # GET /users/1.xml
  def show
    
    if @user.nil?
      flash[:error] = "Sorry, we could not find that user"
      redirect_to "/"
      return
    end
    @page_title = @user.full_name
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # render new.rhtml
  def new
    @user = User.new
    @page_title = "Sign up"
  end

  def create
    @page_title = "Sign up"
    @user = User.new(params[:user])
    if captcha_valid?(params[:user][:captcha_id], params[:user][:captcha_validation])
        @user.save!
    else
      flash[:error] = "Are you sure you're human? Please enter the text in the image below."
      render :action => 'new'
      return
    end
    self.current_user = @user
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
    UserNotifier.deliver_signup_notification(@user)
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  # GET /users/1;edit
  def edit  
    @user = User.find(params[:id])
    if (@user.id == current_user || User.find(current_user).commish?)
      @page_title = "Update profile for #{@user.full_name}"
    else
      flash[:error] = "Sorry, you don't have permission to view this page"
      redirect_to edit_user_url(current_user)
      return false
    end
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update

    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your profile has been updated.'
        format.html { redirect_to edit_user_url(current_user) }
        format.xml  { head :ok }
      else
        flash[:error] = 'An error occurred.  Your profile was not updated.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  def activate
    @user =  User.find_by_activation_code(params[:activation_code])
    if @user && !@user.activated?
      @user.activate
      self.current_user = @user
      flash[:notice] = "Signup complete!"
      UserNotifier.deliver_activation(current_user, home_url) if current_user.recently_activated?
    
      # find the first membership and redirect there
      membership = Membership.find_by_user_id(current_user.id)
      unless membership.nil?
        redirect_to membership_url(membership.biz_entity.id, membership.id)
      else
        unless current_user.store_owner?
          redirect_to user_url(current_user)
        else
          redirect_to store_url(current_user.biz_entities.first)
        end
      end
      
    else
      flash[:error] = "Activation code not found"
      redirect_to "/"
    end
  end
  
  def memberships
    
  end
  
  def forgot_password
    if logged_in?
      redirect_to user_url(current_user)
      return
    end
    
    if request.post? 
      email = params[:password_request][:email]
      @user = User.find_by_email(email)
      unless @user.nil?
        new_password = User.generate_password
        @user.password = new_password
        if @user.save
          UserNotifier.deliver_reset_password(@user, new_password, home_url)
          flash[:notice] = "Your new password has been sent to #{email}."
          redirect_to new_session_url
        else
          flash[:error] = "There was an error resetting your password"
        end
      else
        flash[:error] = "Sorry, we could not find a user with that email"
      end
    end
    
    
  end
  
end
