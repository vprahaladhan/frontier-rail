class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save
    session[:user_id] = @user.id
    session[:user_name] = @user.name
    session[:admin] = @user.admin
    redirect_to user_path(@user.id)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
  end

  def show
    @user = User.find_by_id(params[:id].to_i)
    if (session[:user_id].nil?) then
      redirect_to '/'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :happiness, :nausea, :height, :tickets, :password, :admin)
  end
end
