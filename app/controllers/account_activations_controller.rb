class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
            #authenticated? is in user.rb
            #checks if remember_digest is not nil, and check if remember_digest == params[:id]    
            #params[:id] is to get :id (== encrypted token in activation URL)
            #activation URL ... https://www.example.com/account_activations/*****/edit?email=test%40example.com
            # ~ https://www.example.com/users/1/edit
      user.activate   #activate method is in user.rb
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
