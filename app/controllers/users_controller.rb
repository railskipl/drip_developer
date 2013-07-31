class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index,:edit,:update,:destroy]
  before_filter :correct_user, :only => [:edit,:update,:show]
  
  def index
    @users = User.all
  end
  
  
  def show
    @user = User.find(params[:id])
    @emails = current_user.emails
   end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => {:success => "Welcome #{@user.name}"}
    else
      render 'new'
    end
   end
   
   def edit
  	@user = User.find(params[:id])
   end
   
   def update
      @user = User.find(params[:id])
     if @user.update_attributes(params[:user])
      
       redirect_to @user, :flash => {:success => "Profile updated."}
     else
        @title = "Edit user"
        render 'edit'
     end
   end
   
   def destroy
     User.find(params[:id]).destroy
     redirect_to users_path, :flash => {:success => "User destroyed"}
   end
   
   private
   
   def authenticate
     deny_access unless signed_in?
   end
   
   def correct_user
     @user = User.find(params[:id])
     redirect_to root_path,  alert: 'Unauthorised access to you' unless current_user?(@user)
   end
   
end