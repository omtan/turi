require 'rails_helper'


RSpec.feature "Waypoint model test" do
  describe "waypoint" do

    it "is invalid without a latitude" do
      expect {
        FactoryGirl.create(:waypoint, :lat => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid without a longitude" do
      expect {
        FactoryGirl.create(:waypoint, :lng => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is valid" do
      expect {
        FactoryGirl.create(:waypoint)
      }.not_to raise_error
    end
  end
end

