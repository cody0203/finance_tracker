class UsersController < ApplicationController
  def my_portfolio
    @followed_stocks = current_user.stocks
  end
end
