class UsersController < ApplicationController
  protect_from_forgery :only => ["create"]
  def home

  end

  def create
    @user = User.new(:name => params[:username])
    @user.save
    render action: :show
  end

  def show

  end
end
