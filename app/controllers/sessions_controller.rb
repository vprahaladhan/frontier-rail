class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = nil
    if !auth.nil? then 
      @user = User.find_by(email: auth['info']['email'], provider: auth['provider'])
      if (@user.nil?) then 
        @user = User.new
        @user.name = auth['info']['name']
        @user.email = auth['info']['email']
        @user.image = auth['info']['image']
        @user.password_digest = SecureRandom.hex(32)
        @user.provider = auth['provider']
        @user.save
        # session[:user_id] = @user.id
        # redirect_to root_path
      end  
    else
      @user = User.find_by(email: user_params[:email], provider: user_params[:provider])
      if @user.nil? || !@user.authenticate(user_params[:password]) then 
        @user.errors.add(:email, "Not valid")
        return render :new
      end
    end
    session[:user_id] = @user.id
    session[:username] = @user.name
    redirect_to root_path
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def user_params
    params.require(:user).permit(:email, :password, :provider)
  end
end