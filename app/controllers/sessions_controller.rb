class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_or_create_by(uid: auth['uid']) do |u|
      u.name = auth['info']['name']
      u.email = auth['info']['email']
      u.image = auth['info']['image']
      u.provider = auth['provider']
    end

    session[:user_id] = @user.id

    redirect_to root_path
  end

  def destroy
    session.delete :user_id
    redirect_to '/'
  end

  private

  def auth
    puts "Auth #{request.env['omniauth.auth']}"
    request.env['omniauth.auth']
  end
end
