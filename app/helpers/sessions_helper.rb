module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember   #remember is in user.rb. put new_token in remember_token
    cookies.permanent.signed[:user_id] = user.id    #signed = signature for encryption
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user
          #if session exists, set the user as current user
          #if not, find user from cookie and login
          #login to permenent session by user from session[:user_id] or cookies[:user_id]
    if (user_id = session[:user_id])
          #if session of user_id exists by adding the session into user_id
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
          #if cookie of user_id exists by adding the cookie into user_id
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def current_user?(user)
    user && user == current_user
  end
  
  def logged_in?
    !current_user.nil?   #true if user is logged in
  end
  
  def forget(user)
    user.forget  #forget is in user.rb. it delete remember_digest
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
    
  def log_out
    forget(current_user)   #this forget is here above.
    session.delete(:user_id)
    @current_user = nil
  end
      
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
        # request.original_url is to obtain the requested url
        # "if request.get?" = not applied if Post, Patch, Delete
  end
  
end
