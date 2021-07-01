class UsersController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

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
      session[:username] = @user.name
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
    if session[:username] == 'admin' then
      User.delete(params[:id])
    else
      return head(:forbidden)
    end
  end

  def index
    if (session[:username] == 'admin') then 
      @users = User.all
    else 
      @users.errors.add(:name, "You should be an admin to view this page!")
      render :index
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    if (!@user.nil? && @user.id == session[:user_id]) then
      @trips = Trip.user_trips(@user.id)
    else
      if @user.name == 'admin' then 
        @trips = Trip.user_trips(@user.id)
      else
        puts "Redirecting to.."
        redirect_to '/'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :uid, :provider, :image)
  end

  def require_login
    return head(:forbidden) unless session.include? :user_id
  end
end