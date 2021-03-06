class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  include SessionsHelper

  def index
    @users = User.all
    @product = Product.find_by(user_id: current_user.id)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    if logged_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @cart = Cart.create!(user_id: @user.id)
      session[:user_id] = @user.id
      flash[:notice] = "*Your registration was successful!*"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    redirect_if_not_user
  end

  def update
    @user = User.find(params[:id])
    redirect_if_not_user
    if @user.update(user_params)
      flash[:notice] = "*Your profile was updated successfully!*"
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    redirect_if_not_user
    @user.destroy
    reset_session
    flash[:notice] = "*Your account was deleted successfully!*"
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def redirect_if_not_user
    if @user.id != current_user.id
      redirect_back(fallback_location: root_path)
    end
  end

end
