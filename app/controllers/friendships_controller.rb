class FriendshipsController < ApplicationController
  def index
    @friend_list = current_user.friends
  end

  def destroy
    friend = User.find(params[:id])
    friendship = Friendship.where(user_id: current_user.id, friend_id: friend.id).first
    friendship.destroy
    flash[:notice] = "You was successfully unfollowed user #{friend.first_name || friend.last_name || 'Anonymous'}."
    redirect_to friendships_path
  end
end
