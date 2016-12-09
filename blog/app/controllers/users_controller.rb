class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(create_user_param_filter)
    if @user.save
      redirect_to log_in_path, flash: {success: "User Successfully Registred. You can login now."}
    else 
			render new_user_path, flash: {danger: "User Register Failed!!!"}
		end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def destroy
    if User.delete_user(params[:id])
      redirect_to articles_path, flash[:notice]= "User Successfully Deleted." 
    else 
      redirect_to articles_path, flash[:alert] = "User Deletion Failed!!!"
    end
  end

  private
    def create_user_param_filter
			params.permit(:name, :username, :email, :password, :role, :subscriber)
    end
end
