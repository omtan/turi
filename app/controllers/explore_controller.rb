class ExploreController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def list
    @start_loc_trips = Trip.where(public: true)
                           .where.not(start_loc: nil)
                           .where.not(start_loc: '')
                           .where.not(start_loc_latitude: nil)
                           .where.not(start_loc_longitude: nil)

    @end_loc_trips = Trip.where(public: true)
                         .where.not(end_loc: nil)
                         .where.not(end_loc: '')
                         .where.not(end_loc_latitude: nil)
                         .where.not(end_loc_longitude: nil)

    @trip_items = []

    @start_loc_trips.each do |trip|
      trip_item = to_json trip, :start_loc
      @trip_items.push(trip_item)
    end

    @end_loc_trips.each do |trip|
      trip_item = to_json trip, :end_loc
      @trip_items.push(trip_item)
    end

    render json: @trip_items
  end

  def to_json(trip, type)
    {
        id: trip.id,
        title: trip.title,
        description: trip.description,
        start_loc: trip.start_loc,
        end_loc: trip.end_loc,
        start_date: trip.start_date,
        end_date: trip.end_date,
        url: trip_path(trip),
        lat: type == :start_loc ? trip.start_loc_latitude : trip.end_loc_latitude,
        long: type == :start_loc ? trip.start_loc_longitude : trip.end_loc_longitude,
        type: type
    }
  end

end
