class UserNotifier < ActionMailer::Base
  include ActionController::UrlWriter
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = activate_url(user.activation_code)
  
  end
  
  def activation(user, url)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = url
  end
  
  def reset_password(user, new_password, url)
    setup_email(user)
    @subject    +=  'Your password has been reset'
    @body       = {"user" => user, "new_password" => new_password, "url" => url}
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email_with_name}"
      @from        = "WildFire Team <sparky@sparkwildfire.com>"
      @subject     = "[WildFire] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
