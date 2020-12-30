class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
          #user_params is external method below to initialize hash, used instead of User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user   #go to user profile page = redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
