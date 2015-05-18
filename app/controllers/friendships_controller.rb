class FriendshipsController < ApplicationController

  before_action :set_user
  before_action :set_friendship

  def destroy
    if @friendship.destroy
      flash[:notice] = I18n.t 'user_friendship_removed'
    else
      flash[:alert] = I18n.t('user_friendship_not_removed')
    end
    redirect_to current_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_friendship
    @friendship = @user.friendships.find(params[:id])
  end

end
