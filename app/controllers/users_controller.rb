class UsersController < ApplicationController
  def my_portfolio
    @followed_stocks = current_user.stocks
  end

  def show
    @user = User.find(params[:id])
    @followed_stocks = @user.stocks
  end
end
