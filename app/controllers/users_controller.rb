class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.per_pag
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".checkmail"
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    flash[:success] = t ".delete"
    redirect_to users_path
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".update"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = t ".please"
      redirect_to login_path
    end
  end

  def correct_user
    @user = User.find_by(params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".error_messages"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    redirect_to root_path unless current_user?(@user)
  end
end
