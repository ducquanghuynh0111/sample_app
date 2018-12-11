class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user&.authenticated?(:activation, params[:id]) && !user.activated?
      user.activate
      log_in user
      flash[:success] = t ".account"
      redirect_to user
    else
      flash[:danger] = t ".invalid"
      redirect_to root_path
    end
  end
end
