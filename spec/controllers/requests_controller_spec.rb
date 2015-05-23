require 'rails_helper'

RSpec.describe RequestsController, type: :controller do

  before do
    @user_one = FactoryGirl.create(:user)
    @user_two = FactoryGirl.create(:user)

    sign_in(@user_one)
    request.env["HTTP_REFERER"] = root_path
  end

  describe "POST #create" do
    context 'with valid attributes' do
      it "creates a friend request" do
        expect {
          post :create, user_id: @user_one.id, receiver_id: @user_two.id
        }.to change(Request, :count).by(1)
      end

      it "renders the friends user page with notice" do
        post :create, user_id: @user_one.id, receiver_id: @user_two.id
        expect(response).to redirect_to user_path(@user_two)
      end
    end

    context "with invalid attributes" do
      it 'does not create a friend request to yourself' do
        expect {
          post :create, user_id: @user_one.id, receiver_id: @user_one.id
        }.to_not change(Request, :count)
      end

      it 'does not create a friend request to someone who doesnt exist' do
        expect {
          post :create, user_id: @user_one.id, receiver_id: 3837
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end
  end

  describe 'POST #accept' do
    before do
        @friendRequest = Request.create(user_id: @user_one.id, receiver_id: @user_two.id)
    end
    it "Deleted the request and creates a Friendship when the request is accepted" do
        expect {
            post :accept, :user_id => @user_one, :id => @friendRequest.id
        }.to change(Request, :count).by(-1) and change(Friendship, :count).by(1)
    end 
  end



  describe 'DELETE #destroy' do
    before do
      @friendRequest = Request.create(user_id: @user_one.id, receiver_id: @user_two.id)
    end
    context 'with valid attributes' do
      it 'the requesting user destroys the request' do
        expect {
            delete :destroy, :user_id => @user_one, id: @friendRequest.id
        }.to change(Request, :count).by(-1)
      end

      it 'the requested user destroys the request' do
        sign_out(@user_one)
        sign_in(@user_two)
        expect {
            delete :destroy, user_id: @user_one, id: @friendRequest
        }.to change(Request, :count).by(-1)
      end

      it 'the requesting user renders your user page' do
        delete :destroy, user_id: @user_one, id: @friendRequest
        expect(response).to redirect_to root_path # redirect_to :back
      end

      it 'the requested user renders the requesting user page' do
        sign_out @user_one
        sign_in @user_two
        delete :destroy, user_id: @user_one, id: @friendRequest
        expect(response).to redirect_to root_path
      end
    end

    # Should not happend!
    context 'with invalid attributes' do
      it 'doesnt destroy a request' do
        expect {
          delete :destroy, user_id: @user_one, id: 231
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end
end
