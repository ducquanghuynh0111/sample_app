class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".sign_up_success"
      redirect_to @user
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".error_messages"
    redirect_to root_path
  end
end
