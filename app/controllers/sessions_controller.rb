class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if !auth.nil? then 
      @user = User.find_by(email: auth['info']['email'], provider: auth['provider'])
      if (@user.nil?) then 
        @user.name = auth['info']['name']
        @user.email = auth['info']['email']
        @user.image = auth['info']['image']
        @user.password_digest = SecureRandom.hex(32)
        @user.provider = auth['provider']
        @user.uid = auth['uid']
        @user.save
      end  
    else
      @user = User.find_by(email: user_params[:email], provider: user_params[:provider])
      if @user.nil? || !@user.authenticate(user_params[:password]) then 
        @user = User.new(user_params)
        @user.errors.add(:base, "Invalid credentials!")
        return render :new
      end
    end
    session[:user_id] = @user.id
    session[:username] = @user.name
    redirect_to user_path(@user)
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