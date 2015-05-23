require 'rails_helper'

RSpec.feature 'Request and friendship' do
    before do
        @userOne = FactoryGirl.create(:user)
        @userTwo = FactoryGirl.create(:user)

        login_as(@userOne, scope: :user)
        visit user_path(@userTwo)

        within "#friendship_div" do
            click_link 'create_request_id'
        end
        expect(page).to have_content(I18n.t('user_request_added'))
        expect(current_path).to eq(user_path(@userTwo))

        within "#friendship_div" do
            expect(page).to have_selector(:link_or_button, "remove_request_id")
        end
    end

    scenario "Create a user request on friends page, let the friend log in and accept it via requst widget on his/her own userpage" do
        logout
        login_as(@userTwo, scope: :user)

        visit dashboard_path

        within "#friendship_request_widget" do
            expect(page).to have_content(@userOne.name)
            expect(page).to have_selector(:link_or_button, "accept_friend_request_#{@userOne.name}")
            expect(page).to have_selector(:link_or_button, "remove_friend_request_#{@userOne.name}")

            click_link "accept_friend_request_#{@userOne.name}"
        end

        expect(page).to have_content(I18n.t('user_friendship_confirmed'))


        visit user_path(@userTwo)
        within "#friendship_widget" do
            expect(page).to have_content(@userOne.name)
            expect(page).to have_link("delete_friend_#{@userOne.name}")
        end

         visit user_path(@userOne)
         within "#friendship_widget" do
            expect(page).to have_content(@userTwo.name)
            expect(page).to_not have_link("delete_friend_#{@userTwo.name}")
        end
      end

      scenario "Create a User request on friends page, and accept it on requestors page" do
            logout 
            login_as(@userTwo, scope: :user)

            visit user_path(@userOne)

            within "#friendship_div" do
                expect(page).to have_selector(:link_or_button, "accept_friend_request_#{@userOne.name}")
                click_link "accept_friend_request_#{@userOne.name}"
            end

            expect(page).to have_content(I18n.t('user_friendship_confirmed'))

            # redirects :back
            expect(page.current_path).to eq(user_path(@userOne))
            
            within "#friendship_widget" do
                expect(page).to have_content(@userTwo.name)
            end

            visit user_path(@userTwo)
            within "#friendship_widget" do
                expect(page).to have_content(@userOne.name)
                expect(page).to have_selector(:link_or_button, "delete_friend_#{@userOne.name}")
            end

      end 

end
