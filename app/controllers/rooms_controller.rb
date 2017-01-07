class RoomsController < ApplicationController
  protect_from_forgery :only => ["create"]
  def join
    @room = Room.find(params[:room_id])
    redirect_to "/rooms/home/#{@room.id}"
  end

  def delete
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
    @room.users.delete(@user)
    redirect_to "/users/show/#{@user.id}"
  end

  def create
    @user_id = params[:users_id]
    @room = Room.new(name: params[:roomname])
    @room.users << User.find(@user_id)
    @room.save
    redirect_to "/users/show/#{@user_id}"
  end

  def home

  end
end
