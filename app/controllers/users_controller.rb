class UsersController < ApplicationController
  def show; end

  def new
    @user = User.new
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

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".load_user.error_messages"
    redirect_to root_path
  end
end
