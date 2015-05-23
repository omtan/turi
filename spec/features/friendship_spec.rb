require 'rails_helper'

RSpec.feature 'Friendship' do
  before do
    @userOne = FactoryGirl.create(:user)
    @userTwo = FactoryGirl.create(:user)

    login_as(@userOne, scope: :user)

  end

  context 'with request made' do
    before do
      # @userTwo request a Friendship with @userOne
      @friendRequest = FactoryGirl.create(:request, user_id: @userTwo.id, receiver_id: @userOne.id)
      visit dashboard_path
    end

    context 'accepts a request' do
      before do
          within "#friendship_request_widget" do
            click_link "accept_friend_request_#{@userTwo.name}"
          end
      end

      scenario 'the view is correct for the user' do
        expect(page).to have_content(I18n.t('user_friendship_confirmed'))
        expect(page).to_not have_selector(:link_or_button, "accept_friend_request_#{@userTwo.name}")

        visit user_path(@userOne)
        within("#friendship_widget") do
          expect(page).to have_content "#{@userTwo.name}"
          expect(page).to have_selector(:link_or_button, "delete_friend_#{@userTwo.name}")
        end

      end

      scenario 'the view is correct for the added friend' do
        logout
        login_as(@userTwo, scope: :user)
        visit user_path @userTwo

        within("#friendship_widget") do
          expect(page).to have_content "#{@userOne.name}"
          expect(page).to have_selector(:link_or_button, "delete_friend_#{@userOne.name}")
        end

        click_link "delete_friend_#{@userOne.name}"

        within("#friendship_widget") do
          expect(page).to_not have_content "#{@userOne.name}"
          expect(page).to_not have_selector(:link_or_button, "delete_friend_#{@userOne.name}")
        end
      end

      scenario 'it is removed for the unfriended' do
        visit user_path(@userTwo)
        click_link "delete_friend_#{@userTwo.name}"
        logout
        login_as(@userTwo, scope: :user)
        visit user_path @userTwo

        within("#friendship_widget") do
          expect(page).to_not have_content "#{@userOne.name}"
          expect(page).to_not have_selector(:link_or_button, "delete_friend_#{@userOne.id}")
        end
      end
    end
  end
end
