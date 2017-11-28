class PasswordResetsController < ApplicationController
  before_action :gett_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "views.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "views.danger"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("views.empty")
      render :edit
    elsif @user.update_attributes(user_params)
      update_success
    else
      render :edit
    end
  end

  def edit; end

  private

  def update_success
    log_in @user
    @user.update_attribute :reset_digest, nil
    flash[:success] = t "views.update"
    redirect_to @user
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def gett_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "views.check"
    redirect_to new_password_reset_url
  end
end
