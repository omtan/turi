require 'rails_helper'

RSpec.feature "Equipment Assigment" do
    before do
        @user = FactoryGirl.create(:user)
        @editor = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip, :user_id => @user.id)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @editor.id, :participant_role_id => ParticipantRole.editor.id)

        @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
        @equipment_item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)
        @equipment_assignment = FactoryGirl.build(:equipment_assignment, :equipment_item_id => @equipment_item.id)
        login_as(@user, :scope => :user)
        visit trip_equipment_list_path(@trip, @equipment_list)
    end

    scenario "Create a new assigment" do
        # TODO use CSS to find the correct form
        #within @equipment_item.name + '_tag' do
        #    select @equipment_assignment.number, :from => "equipment_assignment_number"
        #    click_button 'submit'
        #end

        #expect(page.current_path).to eq(trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item))
        #expect(page).to have_content(I18n.t('trip_equipment_assignment_created'))
        #expect(page).to have_content(@user.name)
        #expect(page).to have_content(@equipment_assignment.number)
    end

    scenario "Delete assigment" do
        @equipment_assignment = FactoryGirl.create(:equipment_assignment, :equipment_item_id => @equipment_item.id, :user_id => @user.id)
        visit trip_equipment_list_path(@trip, @equipment_list)
                
        expect(page).to have_content(@user.name)
        click_link 'delete_equipment_assignment'
        expect(page.current_path).to eq trip_equipment_list_path(@trip, @equipment_list)
        expect(page).to have_content(I18n.t('trip_equipment_assignment_deleted'))
    end

end



