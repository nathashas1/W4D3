class SessionsController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end 
  
  def create
    @user = User.find_by_credentials(
      params[:user][:user_name], 
      params[:user][:password])
      
      if @user 
        login!(@user)
      else
        flash.now[:errors] = ['Invalid Login Credentials. Boo.']
        render :new
      end
    redirect_to user_url(@user)
  end
  
  def destroy
    logout!
    redirect_to new_session_url
  end
  
end