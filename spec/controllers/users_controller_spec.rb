require 'rails_helper'

=begin
Use let to define a memorized helper method. The value will be cached
across multiple calls in the same example but not across examples.

Note that let is lazy-evaluated: it is not evaluated until the first time
the method it defines is invoked. You can use let! to force the method's
invocation before each example.
=end

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    #session[:user_id] = user.id
    sign_in(user)
  end

  describe "GET #show" do
    it "assigns the requested user to user" do
      get :show, id: user
      expect(assigns(:user)).to eql(user)
    end

    it "directs to user page when user id exist" do
      get :show, id: user.id
      expect(response).to render_template(:show)
    end

    it " directs to root page when user id doesn't exist" do
      get :show, id: 202
      expect(response).to redirect_to(dashboard_path)
      expect(flash[:alert]).to have_content(I18n.t('user_id_not_found'))
    end

    it " assigns only one friendship for the current user and the passed user" do
      friend_one = FactoryGirl.create(:user)
      friend_two = FactoryGirl.create(:user)
      friendship_one = FactoryGirl.create(:friendship, user: user, friend: friend_one)
      friendship_two = FactoryGirl.create(:friendship, user: user, friend: friend_two)
      get :show, id: friend_one.id
      expect(assigns(:friendship)).to eql(friendship_one)
      expect(assigns(:friendship)).not_to eql(friendship_two)
    end

  end

  describe "GET #edit" do
    it "sends us to edit" do
      get :edit, id: user.id
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do


    context "with valid attributes" do
      it "locates the requested @user" do
        put :update, id: user, user: FactoryGirl.attributes_for(:user)
        expect(assigns(:user)).to eql(user)
      end

      it "changes @users attributes" do
        put :update, id: user, user: FactoryGirl.attributes_for(:user, name: "Runar", email: "runar@uit.no")
        user.reload
        expect(user.name).to eql("Runar")
        expect(user.email).to eql("runar@uit.no")
      end

      it "redirects to the updated contact" do
        put :update, id: user, user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to user
      end
    end

    context "with invalid attributes" do
      it "locates the requested user" do
        put :update, id: user, user: FactoryGirl.attributes_for(:invalid_user)
        expect(assigns(:user)).to eql(user)
      end

      it "does not change users attributes" do
        email = user.email
        put :update, id: user, user: FactoryGirl.attributes_for(:user, name: "Larry", email: nil)
        user.reload
        expect(user.name).to_not eql("Larry")
        expect(user.email).to eql(email)
      end

      it "re-renders the edit method" do
        put :update, id: user, user: FactoryGirl.attributes_for(:invalid_user)
        expect(response).to render_template :edit
      end
    end

    context "cant update others people users" do
      it "does not change others attributes" do
        other_user = FactoryGirl.create(:user)
        put :update, id: other_user, user: FactoryGirl.attributes_for(:user, name: "Lollypop")
        expect(other_user.name).to_not eql("Lollypop")
      end
    end
  end

end
