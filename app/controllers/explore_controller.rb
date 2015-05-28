class ExploreController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def list
    @trips = Trip.where(public: true)
                 .where.not(start_loc: nil)
                 .where.not(start_loc: '')
                 .where.not(start_loc_latitude: nil)
                 .where.not(start_loc_longitude: nil)

    @trip_items = []

    @trips.each do |trip|
      trip_item = {
          id: trip.id,
          url: trip_public_path(trip),
          lat: trip.start_loc_latitude,
          long: trip.start_loc_longitude
      }
      @trip_items.push(trip_item)
    end

    render json: @trip_items
  end

end
