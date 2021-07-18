class UsersController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    if (user_params[:name] == "admin")
      if (!User.find_by(name: "admin").nil?)
        return head(:forbidden)
      end
    end
    @user = User.create(user_params)
    if @user.valid?
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
    if session[:username] == "admin"
      User.delete(params[:id])
    else
      return head(:forbidden)
    end
  end

  def index
    if (session[:username] == "admin")
      @users = User.all
    else
      @users.errors.add(:name, "You should be an admin to view this page!")
      render :index
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    puts "User >> #{@user.name}"
    if (!@user.nil? && @user.name != "admin" && @user.id == session[:user_id])
      @trips = Trip.user_trips(@user.id)
    else
      if @user.name == "admin"
        # @trips = Trip.user_trips(@user.id)
        @trains = Train.all
      else
        puts "Redirecting to.."
        redirect_to "/"
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
