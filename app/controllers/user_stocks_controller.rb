class UserStocksController < ApplicationController
  def create
    if current_user.can_follow_stock?(params[:ticker])
      @stock = Stock.check_db(params[:ticker])

      if @stock.blank?
        @stock = Stock.new_lookup(params[:ticker])
        @stock.save
      end

      @user_stock = UserStock.create(user: current_user, stock: @stock)
      flash[:notice] = "Stock #{@stock.name} was added to your portfolio"
      redirect_to my_portfolio_path
    else
      flash[:alert] = 'Your alreay followed this stock'
      redirect_to my_portfolio_path
    end
  end
end
