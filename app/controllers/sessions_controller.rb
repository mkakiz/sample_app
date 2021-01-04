class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)  #sessions form says email is in session key
    if user && user.authenticate(params[:session][:password])   #checking a user has the email and the password
      log_in user   #log_in is defined in sessions_helper
      remember user   #remember is in user.rb. put encrypted new_token in remember_digest
      redirect_to user   # same as redirect_to user_url(user), /users/*
    else
      flash.now[:danger] = "Invalid email/password combination"    #.now lets to show flash in rendered page until next action
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
