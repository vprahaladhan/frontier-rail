class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if (user_params[:name] == 'admin') then 
      if (!User.find_by(name: "admin").nil?) then
        return head(:forbidden)
      end
    end
    @user = User.create(user_params)
    if @user.valid? then 
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    if (!session[:user_id].nil? && User.find_by(id: session[:user_id]).name == 'admin') then 
      @users = User.all
    else 
      flash[:error] = "You should be an admin to view this page!"
      render :index
    end
  end

  def show
    @user = User.find_by_id(params[:id].to_i)
    if (session[:user_id].nil?) then
      redirect_to '/'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :uid, :provider, :image)
  end
end