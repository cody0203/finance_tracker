class FriendshipsController < ApplicationController
  def index
    @friend_list = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if !@friends.blank?
        respond_to do |format|
          format.js { render partial: 'friendships/result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = 'User not found'
          format.js { render partial: 'friendships/result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'Please enter email or name to search'
        format.js { render partial: 'friendships/result' }
      end
    end
  end

  def create
    if !current_user.friend_already_followed?(params[:friend])
      friend = User.find(params[:friend])
      friendship = Friendship.create(user: current_user, friend: friend)
      friendship.save
      flash[:notice] = "#{friend.full_name} was added to your friendlist"
      redirect_to friendships_path
    else
      flash[:alert] = 'You already followed this user'
      redirect_to friendships_path
    end
  end

  def destroy
    friend = User.find(params[:id])
    friendship = Friendship.where(user_id: current_user.id, friend_id: friend.id).first
    friendship.destroy
    flash[:notice] = "You was successfully unfollowed user #{friend.first_name || friend.last_name || 'Anonymous'}."
    redirect_to friendships_path
  end
end
