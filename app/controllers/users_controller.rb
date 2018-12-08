class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.per_pag
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".sign_up_success"
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    User.find_by(params[:id]).destroy
    flash[:success] = t ".delete"
    redirect_to users_path
  end

  def update
    @user = User.find_by params[:id]
    if @user.update_attributes(user_params)
      flash[:success] = t ".update"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".load_user.error_messages"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".Please"
    redirect_to login_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    @user = User.find_by params[:id]
    redirect_to root_path unless current_user?(@user)
  end
end
