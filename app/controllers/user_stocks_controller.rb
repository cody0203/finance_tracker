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

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "You was successfully unfollowed stock #{stock.name}."
    redirect_to my_portfolio_path
  end
end
