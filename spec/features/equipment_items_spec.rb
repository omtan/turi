require 'rails_helper'

RSpec.feature "Items for equipment_lists" do
   before do
       @user = FactoryGirl.create(:user)
       @user2 = FactoryGirl.create(:user)
       @user3 = FactoryGirl.create(:user)

       @trip = FactoryGirl.create(:trip, :user_id => @user.id)
       
       FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)
       FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user2.id, :participant_role_id => ParticipantRole.editor.id)
       FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user3.id, :participant_role_id => ParticipantRole.viewer.id)       
       
       @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
       @item = FactoryGirl.build(:equipment_item)
       login_as(@user, :scope => :user)
       
       visit trip_path(@trip)
   end

   scenario "Create a item" do
 
       visit trip_equipment_list_path(@trip, @equipment_list)
       expect(page).to have_content(@equipment_list.name)
    
       # The form is hidden, but capybara ignores this 
       fill_in 'equipment_item_name', with: @item.name
       fill_in 'equipment_item_price', with: @item.price
       fill_in 'equipment_item_number', with: @item.number

       click_button 'submit'

       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_item_created')

       expect(page).to have_content(@item.name)

   end

   scenario "Edit a item" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)


       visit trip_equipment_list_path(@trip, @equipment_list)
       click_link "edit-item-#{@item.id}-btn"
       expect(page.current_path).to eq edit_trip_equipment_list_equipment_item_path(@trip, @equipment_list, @item)
       fill_in 'equipment_item_name', with: "something else"

       click_button 'submit'
       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_item_updated')
    
       expect(page).not_to have_content(@item.name)
   end     

   scenario "Delete a item" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)
       
       visit trip_equipment_list_path(@trip, @equipment_list)    
       click_link 'delete_' + @item.id.to_s

       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_item_deleted')
       expect(page).not_to have_content(@item.name)
   end

   scenario "The creator (without owner role) of the item, can delete it" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user2.id)
       
       logout(:user)
       login_as(@user2, :scope => :user)
       visit trip_equipment_list_path(@trip, @equipment_list)
       expect(page).to have_link('delete_' + @item.id.to_s)

       click_link 'delete_' + @item.id.to_s
       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_item_deleted')
   end

   scenario "Editor can't delete others items but can edit it" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)

       logout(:user)
       login_as(@user2, :scope => :user)
       visit trip_equipment_list_path(@trip, @equipment_list)
       expect(page).not_to have_link('delete_' + @item.id.to_s)
       expect(page).to have_link('Edit ' + @item.name)

       # edit the item 
       click_link 'Edit ' + @item.name
       fill_in 'equipment_item_name', with: 'Something'
       click_button 'submit'
       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_item_updated')
       expect(page).not_to have_content(@item.name)
   end

   scenario "Viewers can't edit or delete item" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)

       logout(:user)
       login_as(@user3, :scope => :user)
       visit trip_equipment_list_path(@trip, @equipment_list)
       expect(page).not_to have_link 'Edit ' + @item.name
       expect(page).not_to have_link 'delete_' + @item.id.to_s
   end
end
