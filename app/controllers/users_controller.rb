class UsersController < ApplicationController
  protect_from_forgery :only => ["create"]
  def home

  end

  def create
    @user = User.find_by(:name => params[:username])
    if @user
      redirect_to "/users/show/#{@user.id}"
    else
      @user = User.new(:name => params[:username])
      if @user.save
        redirect_to "/users/show/#{@user.id}"
      end
    end
  end

  def show
    @user_id = params[:id]
    @room = Room.includes(:users).where('users.id' => @user_id)
  end
end
