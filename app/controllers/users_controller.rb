class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy   #limit destory action for only admin


  def new
    @user = User.new
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
          #user_params is external method below to initialize hash, used instead of User.new(params[:user])
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user    #go to user profile page = redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user   #go to user profile page = redirect_to user_url(@user)
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end  
  
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
    def logged_in_user
      unless logged_in?
        store_location   # in sessions helper, storing forwarding url
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end  
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)   
            # = unless @user == current_user
            # current_user?(user) is defined in session_helper
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
  
end
