class SessionsController < ApplicationController
  def new
  end

  def create
    user, path = User.authenticate(params[:username], params[:password], request.env['HTTP_REFERER'])
    if user
      session[:user_id] = user.id
      redirect_to path, flash[:notice] => "Logged in!"
    else
      render new_session_path, flash[:danger] = "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to articles_path, :notice => "Logged out!"
  end

  private
    def session_params
      params.permit(:username, :password)
    end
end
