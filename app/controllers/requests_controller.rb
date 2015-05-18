class RequestsController < ApplicationController

  before_action :set_user, only: [:destroy, :accept]
  before_action :set_request, only: [:destroy, :accept]

  before_action :set_receiver, only: [:create]

  def create
    @request = current_user.requests.build receiver_id: @receiver.id

    if current_user.id.eql? @receiver.id
      flash[:error] = t 'user_request_not_yourself'
    elsif @request.save
      flash[:notice] = I18n.t 'user_request_added'
    else
      flash[:error] = I18n.t 'user_request_not_added'
    end
    redirect_to user_path @receiver
  end

  def accept
    # Create a friendship for the user who started the request. The receiver should be the current user who accepts the request.
    friendship = @request.user.friendships.build friend_id: @request.receiver_id
    if friendship.save
      @request.destroy
      flash[:notice] = I18n.t 'user_friendship_confirmed'
    else
      flash[:alert] = t('user_friendship_not_confirmed')
    end
    redirect_to :back
  end

  def destroy
    # We get the current user and find the
    if @request.destroy
      flash[:notice] = I18n.t 'user_request_destroyed'
    else
      flash[:alert] = t 'user_request_destroy_not_destroyed'
    end
    redirect_to :back
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_request
    @request = @user.requests.find(params[:id])
  end

  def set_receiver
    @receiver = User.find(params[:receiver_id])
  end

end
