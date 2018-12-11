class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_activate user
    else
      flash.now[:danger] = t ".error_messages"
      render :new
    end
  end

  def check_activate user
    if user.activated?
      log_in user
      check_rememember user
      redirect_back_or user
    else
      message = t ".not_activated"
      flash[:warning] = message
      redirect_to root_path
    end
  end

  def check_rememember user
    if params[:session][:remember_me] == Settings.sesions.remember
      remember user
    else
      forget user
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
