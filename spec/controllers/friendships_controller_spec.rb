require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do

  before do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)

    sign_in(@user)

    @friendRequest = FactoryGirl.create(:request, user_id: @user.id, receiver_id: @friend.id)
  end


  describe 'DELETE #destroy' do

    it 'should delete a friendship if a friendship exist, and redirect to current_user' do
      @friendship = FactoryGirl.create(:friendship, user_id: @user.id, friend_id: @friend.id)

      expect {
        delete :destroy, user_id: @user, id: @friendship.id
      }.to change(Friendship, :count).by(-1)

      expect(flash[:notice]).to eql(I18n.t('user_friendship_removed'))
      expect(response).to redirect_to user_path(@user)
    end
  end

end
