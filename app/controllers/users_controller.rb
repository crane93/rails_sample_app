class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) #params[:id]にはリクエストのあれが設定される
    #debugger
  end

  def new
  end
end
