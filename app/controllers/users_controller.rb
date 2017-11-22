class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(new create index)

  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      remember user
      flash[:success] = t "controller.succ"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controller.edit"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controler.del"
    else
      flash[:danger] = t "controller.fail"
    end
    redirect_to users_url
  end

  private

  def find_user
    load_user
    return if @user
    flash[:danger] = t "controller.err"
    redirect_to signup_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controller.unless"
      redirect_to login_url
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
  end

  def correct_user
    load_user
    redirect_to root_url unless @user == current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
